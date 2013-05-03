package RT::Scrip;
use strict;
no warnings qw/redefine/;

# {{{ sub IsApplicable

=head2 IsApplicable

Calls the  Condition object\'s IsApplicable method

Upon success, returns the applicable Transaction object.
Otherwise, undef is returned.

If the Scrip is in the TransactionCreate Stage (the usual case), only test
the associated Transaction object to see if it is applicable.

For Scrips in the TransactionBatch Stage, test all Transaction objects
created during the Ticket object's lifetime, and returns the first one
that is applicable.

=cut

sub IsApplicable {
    my $self = shift;
    my %args = ( TicketObj      => undef,
                 TransactionObj => undef,
                 @_ );

    my $return;

#!!pape: deactivate_scrip.patch {{
        require RT::QueueDeactivatedScrip;
        my $info = new RT::QueueDeactivatedScrip( $self->CurrentUser );
        my $ticket = $args{'TicketObj'};
        if ( $ticket && $ticket->QueueObj &&
             $info->ScripIsDeactivatedForQueue( $ticket->QueueObj->Id, $self->Id ) ) {
            $RT::Logger->info( "Scrip ".$self->Id." has NOT been applied, since it is deactivated for Queue ".$ticket->QueueObj->Name );
            $self->ConditionObj->DESTROY;
            return (undef);
        } else {
            $RT::Logger->debug( "Scrip ".$self->Id." has been applied, since it is not deactivated for Queue ".$ticket->QueueObj->Name );
        }
#!!pape: deactivate_scrip.patch }}

    eval {

	my @Transactions;

        if ( $self->Stage eq 'TransactionCreate') {
	    # Only look at our current Transaction
	    @Transactions = ( $args{'TransactionObj'} );
        }
        elsif ( $self->Stage eq 'TransactionBatch') {
	    # Look at all Transactions in this Batch
            @Transactions = @{ $args{'TicketObj'}->TransactionBatch || [] };
        }
	else {
	    $RT::Logger->error( "Unknown Scrip stage:" . $self->Stage );
	    return (undef);
	}
	my $ConditionObj = $self->ConditionObj;
	foreach my $TransactionObj ( @Transactions ) {
	    # in TxnBatch stage we can select scrips that are not applicable to all txns
	    my $txn_type = $TransactionObj->Type;
	    next unless( $ConditionObj->ApplicableTransTypes =~ /(?:^|,)(?:Any|\Q$txn_type\E)(?:,|$)/i );
	    # Load the scrip's Condition object
	    $ConditionObj->LoadCondition(
		ScripObj       => $self,
		TicketObj      => $args{'TicketObj'},
		TransactionObj => $TransactionObj,
	    );

            if ( $ConditionObj->IsApplicable() ) {
	        # We found an application Transaction -- return it
                $return = $TransactionObj;
                last;
            }
	}
    };

    if ($@) {
        $RT::Logger->error( "Scrip IsApplicable " . $self->Id . " died. - " . $@ );
        return (undef);
    }

            return ($return);

}

# }}}
1;
