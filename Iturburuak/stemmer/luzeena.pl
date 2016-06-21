#!/usr/bin/perl

use FileHandle;
use IPC::Open2;
use locale;

my $pidFOMA = open2(*Reader, *Writer, "flookup -i -x -b stemmer/xuxen_stem_manex.fst");


while ($sarrera = <STDIN>) {
    $luz = 0;                                                                               
    print Writer $sarrera;                                                                          
    while ((my $returnword = <Reader>) ne "\n") {                                                   
        chomp($returnword);
        if ($luz < length ($returnword)){
            $luz = length ($returnword);                                                            
            $luzeena = $returnword;                                                                 
        }
    }
	if ($luzeena eq "+?") {
		print $sarrera;
	} else {
		print $luzeena."\n";
	}
}

close(Reader); close(Writer);
