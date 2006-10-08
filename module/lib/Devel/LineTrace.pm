package Devel::LineTrace;

$VERSION = '0.1.5';

=head1 NAME

Devel::LineTrace - Apply traces to individual lines.

=head1 SYNPOSIS

    perl -d:LineTrace myscript.pl [args ...]

=head1 DESCRIPTION

This is a class that enables assigning Perl code callbacks to certain
lines in the original code B<without modifying it>. 

To do so prepare a file with the following syntax:

    [source_filename]:[line]
        [CODE]
        [CODE]
        [CODE]
    [source_filename]:[line]
        [CODE]
        [CODE]
        [CODE]

Which will assign the [CODE] blocks to the filename and line combinations.
The [CODE] sections are indented from the main blocks. To temporarily cancel
a callback put a pound-sign (#) right at the start of the line (without 
whitespace beforehand).

The location of the file should be specified by the PERL5DB_LT environment 
variable (or else it defaults to C<perl-line-traces.txt>.)

Then invoke the perl interpreter like this:
   
    perl -d:LineTrace myprogram.pl

=head1 SEE ALSO

L<Devel::Trace>, L<Debug::Trace>

=head1 AUTHORS

Shlomi Fish E<lt>shlomif@vipe.technion.ac.ilE<gt>

=cut

package DB;

my (%files);
sub BEGIN
{
    local (*I);
    my $filename = $ENV{'PERL5DB_LT'} || "perl-line-traces.txt";
    open I, "<$filename";
    my $line;
    $line = <I>;
    while($line)
    {
        chomp $line;
        if (($line =~ /^\s+/) || ($line =~ /^#/))
        {
            $line = <I>;
            next;
        }
        $line =~ /^(.+):(\d+)$/;
        my $filename = $1;
        my $line_num = $2;
        my $callback = "";
        while ($line = <I>)
        {
            if ($line =~ /^\s/)
            {
                $callback .= $line;
            }
            else
            {
                last;
            }
        }
        $files{$filename}{$line_num} = $callback;
    }
    close(I);
}

sub DB
{
    local @saved = ($@, $!, $^E, $,, $/, $\, $^W);
    local($package, $filename, $line) = caller;
    local $usercontext = '($@, $!, $^E, $,, $/, $\, $^W) = @saved;' .
      "package $package;";	# this won't let them modify, alas
    if (exists($files{$filename}{$line}))
    {
        eval $usercontext . " " . $files{$filename}{$line};
    }
}

1;

