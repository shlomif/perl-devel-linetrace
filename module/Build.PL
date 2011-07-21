use strict;
use warnings;

use File::Spec;
use lib File::Spec->catdir(File::Spec->curdir(), "inc");

use Test::Run::Builder;

my $build = Test::Run::Builder->new(
    module_name => "Devel::LineTrace",
    dist_version_from => "lib/Devel/LineTrace.pm",
    license => "mit",
    create_makefile_pl => 'traditional',
    configure_requires =>
    {
        'Module::Build' => 0.36,
    },
    build_requires =>
    {
        'Test::More' => 0,
        'strict' => 0,
        'warnings' => 0,
    },
    meta_merge =>
    {
        resources =>
        {
            repository => "http://svn.berlios.de/svnroot/repos/web-cpan/Devel-LineTrace/",
        },
        keywords =>
        [
            "debug",
            "devel",
            "trace",
            "line",
            "callback",
        ],
    },
);

$build->create_build_script;
