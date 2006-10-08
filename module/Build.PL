use strict;
use warnings;

use File::Spec;
use lib File::Spec->catdir(File::Spec->curdir(), "inc");

use Test::Run::Builder;

my $build = Test::Run::Builder->new(
    module_name => "Devel::LineTrace",
    dist_version_from => "lib/Devel/LineTrace.pm",
    license => "bsd",
);

$build->create_build_script;

