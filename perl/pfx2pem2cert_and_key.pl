#!/usr/bin/perl 

###################################################
##                                                #
#                                                 #
# Script created by Daniel Daloia		  # 
# for FWH Netscalers				  #
#						  #
# Simple script to assist conversion of a PFX 	  #
# certificate to a PEM certificate for use in     #
# a Citrix Netscaler				  #
# 						  #
# daloia_d@subway.com				  #
#						  #
## 						  #
###################################################


use strict;
use warnings;


# Define OpenSSL Location

my $ossl = "/usr/bin/openssl";


# Take in file name

print "\n\nCaution: Make sure certificate filename does not match any \nexisting filename including the one you are replacing in the \/nsconfig\/ssl directory.\n\n\n"; 

# Tool to convert Exported Certificates to pkcs12
print "PFX Input file name: ";
chomp (my $input = <STDIN>);

if (-r $input) {
	print "Input File can be read.\n";
} else {
	print "Error: Input file not found\n";
	exit(1);
}

print "\n";

# Set the output file.

my $output = "${input}.PEM";

# Check for existing output. Rename to .old.<version>

if (-e $output) {
		my $i = `/bin/ls -l | grep -c $output | grep -v grep`;
		my $j = $i++;
		my $outold = "${output}.${j}"; 
		`mv $output $outold`; 
 		print "Warning. Output file $output exists!\nMoved to $outold\n";
	}

# Do the same for .key

my $keyfile = "${input}.key";

if (-e $keyfile) {
                my $i = `/bin/ls -l | grep -c $keyfile | grep -v grep`;
                my $j = $i++;
                my $keyold = "${keyfile}.${j}";
                `mv $keyfile $keyold`; 
                print "Warning. Key file $keyfile exists!\nMoved to $keyold\n";
        }       

# Do the same for .cert

my $certfile = "${input}.cert";

if (-e $certfile) { 
                my $i = `/bin/ls -l | grep -c $certfile | grep -v grep`;
                my $j = $i++;
                my $certold = "${certfile}.${j}";
                `mv $certfile $certold`;
                print "Warning. Cert file $certfile exists!\nMoved to $certold\n";
        }       


# Run the conversion

`$ossl pkcs12 -in $input -out $output`;

# Check for conversation errors

my $result = `grep -c KEY $output`;
if ( $result == 0 ) {
	print "Error in file. Please check .PEM file manually\n";
	exit(1);
} 


#  Open the PEM file to create the key.

print "Writting output for file: $keyfile\n";

open PEMFILE, "<", "$output" or die $!;
open KEYFILE, ">", "$keyfile" or die $!;
while (<PEMFILE>) {
print KEYFILE if /KEY/../END/;
}
close(KEYFILE);
close(PEMFILE);

print "Done\n";

# open the PEM file to create the cert.

print "Writing output for file: $certfile\n";

open PEMFILE, "<", "$output" or die $!;
open CERTFILE, ">", "$certfile" or die $!;
while (<PEMFILE>) {
print CERTFILE if /CERTIFICATE/../END/;
}
close(CERTFILE);
close(PEMFILE);

print "Done.\n";

# Copy the certificate to /nsconfig/ssl

print "\n\nWould you like to copy the certificate and key from the local directory to \/nsconfig\/ssl?\nNote. This will NOT overwrite existing certificates or Keys.\ny or n: ";

chomp(my $copy = <STDIN>);
if ( $copy eq "y") {
	my $cpr = `cp -nv $keyfile $certfile /nsconfig/ssl`;
	if ( $cpr =~ /not/ ) {
                                print "$cpr\nFiles already exist and were not copied. Check the local directory for cert and key files.\nThey will have to be moved manually.\n";
                                exit(1);
                        }

	print "$cpr.\nThe following files were created: $keyfile $certfile\nWould you like to view the contents of the file?\ny or n: ";
	chomp(my $cat = <STDIN>);
	if ( $cat eq "y" ) {
		print "\n\n\nCertificate Private Key file contents:\n\n";
		open NEWKEYFILE, "<", "/nsconfig/ssl/$keyfile" or die $!;
			while (<NEWKEYFILE>) {
			 	chomp;
 				print "$_\n";
 			}	
		close NEWKEYFILE;
		print "\n\n\nCertificate contents:\n\n";
                open NEWCERTFILE, "<", "/nsconfig/ssl/$certfile" or die $!;
                        while (<NEWCERTFILE>) {
                                chomp;
                                print "$_\n";
                        }
                close NEWCERTFILE;


	}
	else {
		print "Done.";
	}

} 
elsif ( $copy eq "n" ) {
	print "Files were not copied to \/nsconfig\/ssl\nOperation Complete\n";
	exit(0);
}
else {
	print "y or n: ";
	chomp(my $last_chance = <STDIN>);
		if ( $last_chance eq "y") {
        		my $cpr = `cp -nv $keyfile $certfile /nsconfig/ssl`;
			if ( $cpr =~ /not/ ) {
				print "$cpr\nFiles are ready exist and were not copied. Check the local directory for cert and key files.\nThey will have to be moved manually.\n";
				exit(1);
			}
			print "$cpr.\nThe following files were created: $keyfile $certfile\nWould you like to view the contents of the file?\ny or n: ";
        chomp(my $cat = <STDIN>);
        if ( $cat eq "y" ) {
                print "\n\n\nCertificate Private Key file contents:\n\n";
                open NEWKEYFILE, "<", "/nsconfig/ssl/$keyfile" or die $!;
                        while (<NEWKEYFILE>) {
                                chomp;
                                print "$_\n";
                        }
                close NEWKEYFILE;
                print "\n\n\nCertificate contents:\n\n";
                open NEWCERTFILE, "<", "/nsconfig/ssl/$certfile" or die $!;
                        while (<NEWCERTFILE>) {
                                chomp;
                                print "$_\n";
                         }
                close NEWCERTFILE;
			}
		}		 
		elsif ( $last_chance eq "n" ) {
		        print "Files were not copied to \/nsconfig\/ssl\nOperation Complete\n";
        		exit(0);
		}
		else {
        		print "Error: Files not copied due to incorrect answer.\nOperation Completed. Cert and Key have been created but not moved.\n";
			
		}
}
exit;
 

