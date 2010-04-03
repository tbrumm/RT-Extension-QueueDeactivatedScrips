=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=cut

use strict;
no warnings qw(redefine);

sub GlobalScripStatus {
    my $self = shift;
    my $ScripId = shift;
    
    $self->LoadByCols( QueueId => 0, ScripId => $ScripId );

    return ( $self->Status || 'active' );
}

sub QueueScripLocalStatus {
    my $self = shift;
    my $QueueId = shift;
    my $ScripId = shift;
    
    $self->LoadByCols( QueueId => $QueueId, ScripId => $ScripId );

    return ( $self->Status || 'inherited' );
}

sub QueueScripStatus {
    my $self = shift;
    my $QueueId = shift;
    my $ScripId = shift;
    
    $self->LoadByCols( QueueId => $QueueId, ScripId => $ScripId );

    return ( $self->Status || $self->GlobalScripStatus($ScripId) );
}

sub ScripIsDeactivatedForQueue {
    my $self = shift;
    my $QueueId = shift;
    my $ScripId = shift;

    return ( $self->QueueScripStatus($QueueId, $ScripId) =~ /^(deactivated|inactive)$/ );
}

1;
