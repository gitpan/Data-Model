use strict;
use warnings;
use Path::Class;


for my $rename_type (qw/ none column_rename model_rename column_model_rename /) {
    for my $driver_config (qw/ none changed-serializer strip changed-serializer-with-strip ignore_undef_value changed-serializer-with-ignore_undef_value strip-ignore_undef_value changed-serializer-with-strip-ignore_undef_value /) {
        my $code = '';
        $code .= +{
            none                => '',
            column_rename       => 'BEGIN{ $ENV{TEST_COLUMN_RENAME} = 1 };'."\n",
            model_rename        => 'BEGIN{ $ENV{TEST_MODEL_RENAME} = 1 };'."\n",
            column_model_rename => 'BEGIN{ $ENV{TEST_COLUMN_RENAME} = 1; $ENV{TEST_MODEL_RENAME} = 1 };'."\n",
        }->{$rename_type};
        

        $code .= q!use t::Utils config => +{
    type   => 'DriverMemcached',
    driver => 'Memcached',
!;
        $code .= +{
            none                            => q!!,
            'changed-serializer'            => qq!    driver_config => {\n        serializer => 'Default',\n    },\n!,
            strip                           => qq!    driver_config => {\n        strip_keys => 1,\n    },\n!,
            ignore_undef_value              => qq!    driver_config => {\n        ignore_undef_value => 1,\n    },\n!,
            'strip-ignore_undef_value'      => qq!    driver_config => {\n        strip_keys => 1,\n        ignore_undef_value => 1,\n    },\n!,
            'changed-serializer-with-strip' => qq!    driver_config => {\n        serializer => 'Default',\n        strip_keys => 1,\n    },\n!,
            'changed-serializer-with-ignore_undef_value'       => qq!    driver_config => {\n        serializer => 'Default',\n        ignore_undef_value => 1,\n    },\n!,
            'changed-serializer-with-strip-ignore_undef_value' => qq!    driver_config => {\n        serializer => 'Default',\n        strip_keys => 1,\n        ignore_undef_value => 1,\n    },\n!,
        }->{$driver_config};
        $code .= q!};
run;
!;

        my $name = join('-', $rename_type, $driver_config) . '.t';
        $name =~ s/none-//g;
        $name =~ s/-none//g;
        $name =~ s/^none.t/basic.t/g;
        my $file = Path::Class::File->new(qw/ t 020_mock driver-memcached /, $name);
        my $fh = $file->openw;
        print $fh $code;
    }
}

#t/020_mock/driver-memcached-changed-serializer-with-strip.t     t/020_mock/driver-memcached-column_rename.t                     t/020_mock/driver-memcached.tt/020_mock/driver-memcached-changed-serializer.t                t/020_mock/driver-memcached-strip.t
