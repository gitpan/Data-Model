use t::Utils config => +{
    type   => 'Iterator',
    driver => 'DBI',
    dsn    => 'dbi:SQLite:dbname=',
};
run;
