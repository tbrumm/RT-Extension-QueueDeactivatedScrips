use inc::Module::Install;
RTx('RT-Extension-QueueDeactivatedScrips');
name('RT-Extension-QueueDeactivatedScrips');
author ('Torsten Brumm <tbrumm@mac.com>');
license('perl');
all_from('lib/RT/Extension/QueueDeactivatedScrips.pm');
auto_install();
&WriteAll();
