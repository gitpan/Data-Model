use t::Utils config => +{
    type   => 'AliasColumn',
    driver => 'DBI',
    dsn    => 'dbi:SQLite:dbname=',
    cache  => 'Memcached',
};
run;
