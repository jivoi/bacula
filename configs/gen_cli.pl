#!/usr/bin/perl -w

use HTML::Template;

$if="/etc/bacula/gen_cli.conf";
$it="/etc/bacula/bacula-cli.conf.in";
$of="/etc/bacula/bacula-cli.conf";
$sch=1;$j=1;$err=0;
my @backup_clients;
open(F,$if) or die "ahtung! net file";
while ($str=<F>){
        if (index($str,"#")==0){next;}
        if ($str=~/^(\S+):(\S+):(.+):(\S+):(\S+)?$/){
                if ($sch>112){$sch=1;$j=1;}
                $nowww="";
                $host = $1;
                $passwd = $2;
                if (defined($5)){$nowww = $5;}
                $iii=$eee="";
                @i = split(";",substr($3,2));@e=split(";",substr($4,2));
                foreach $ii (@i){$iii .= sprintf("File = %s\n",$ii);}
                foreach $ee (@e){$eee .= sprintf("File = %s\n",$ee);}
                push @backup_clients,{HOST => $host, PASSWD => $passwd, SCH => $sch, INCLUDE => $iii, EXCLUDE => $eee, NOWWW => $nowww};
                if ($j % 2 == 0){
                        $sch = $sch - 13;
                }else{
                        $sch = $sch + 14;
                }
                $j++;
                #print $host,"  ",$passwd,"  ",$iii,"   ",$eee,"\n";
        }else{
                print $str;
		$err=1;
        }
}
open(OF,"+> ".$of);
my $template = HTML::Template->new(filename => $it,case_sensitive=>1);
$template->param(BACKUP_CLIENTS => [@backup_clients]);
$template->output(print_to => *OF);
close OF;
if (!$err) {print("Syntax OK\n");}
