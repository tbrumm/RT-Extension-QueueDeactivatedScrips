package RT::Extension::QueueDeactivatedScrips;

use 5.008003;
use warnings;
use strict;
our $VERSION = '0.01';

1;

__END__

=head1 NAME

RT::Extension::QueueDeactivatedScrips - Replacement for global Queue/Scrips
Page.

=head1 SYNOPSIS

This Extension to RT replaces the global Queue/Scrips Page by a modified Version
which offers the possibility to turn global Scrips on and off on a Queue Level.


=over 2

=back

=head1 INSTALLATION

Installation Instructions for RT-Extension-QueueDeactivatedScrips:

	1. perl Makefile.PL
	2. make
	3. make install
	4. make initdb
	5. Add 'RT::Extension::QueueDeactivatedScrips' to 
		@Plugins in RT_SiteConfig.pm
	6. Clear mason cache: rm -rf /opt/rt3/var/mason_data/obj
	7. Restart webserver

=head1 AUTHOR

Torsten Brumm <tbrumm@mac.com>

=head1 COPYRIGHT AND LICENCE
 
Copyright (C) 2010, Torsten Brumm.
 
This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
