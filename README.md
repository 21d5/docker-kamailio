# docker-kamailio

Docker image for [Kamailio].

## Configuration

Any configuration files in the `conf/` directory will be copied to the
`/etc/kamailio/` directory of  the Docker image.

All settings in `kamctlrc` can be passed by using environment variables.
You can also define a keyword by declaring a environment variable with a
`DEF_` prefix.

## Feature flags

Some features can be enabled using `#!define WITH_FEATURE` directives:

* To run in debug mode:
  - define `WITH_DEBUG`

* To enable mysql:
  - define `WITH_MYSQL`

* To enable authentication:
  - enable mysql
  - define `WITH_AUTH`
  - add users using `kamctl`

* To enable IP authentication:
  - enable mysql
  - enable authentication
  - define `WITH_IPAUTH`
  - add IP addresses with group id `1` to `address` table

* To enable persistent user location:
  - enable mysql
  - define `WITH_USRLOCDB`

* To enable presence server:
  - enable mysql
  - define `WITH_PRESENCE`

* To enable nat traversal:
  - define `WITH_NAT`
  - install [RTPProxy]
  - start RTPProxy: `rtpproxy -l _your_public_ip_ -s udp:localhost:7722`
  - option for NAT SIP OPTIONS keepalives: `WITH_NATSIPPING`

* To enable PSTN gateway routing:
  - define `WITH_PSTN`
  - set the value of `pstn.gw_ip`
  - check `route[PSTN]` for regexp routing condition

* To enable database aliases lookup:
  - enable mysql
  - define `WITH_ALIASDB`

* To enable speed dial lookup:
  - enable mysql
  - define `WITH_SPEEDDIAL`

* To enable multi-domain support:
  - enable mysql
  - define `WITH_MULTIDOMAIN`

* To enable TLS support:
  - adjust `conf/tls.cfg` as needed
  - define `WITH_TLS`

* To enable XMLRPC support:
  - define `WITH_XMLRP`
  - adjust `route[XMLRPC]` for access policy

* To enable anti-flood detection:
  - adjust `pike` settings and the `ipban` hash table as needed
  - define `WITH_ANTIFLOOD`

* To block 3XX redirect replies:
  - define `WITH_BLOCK3XX`

* To block 401 and 407 authentication replies:
  - define `WITH_BLOCK401407`

* To enable Voicemail routing:
  - define `WITH_VOICEMAIL`
  - set the value of voicemail.srv_ip
  - adjust the value of voicemail.srv_port

* To enhance accounting:
  - enable mysql
  - define `WITH_ACCDB`
  - add following columns to database:
    ```
    ALTER TABLE acc ADD COLUMN src_user VARCHAR(64) NOT NULL DEFAULT '';
    ALTER TABLE acc ADD COLUMN src_domain VARCHAR(128) NOT NULL DEFAULT '';
    ALTER TABLE acc ADD COLUMN src_ip varchar(64) NOT NULL default '';
    ALTER TABLE acc ADD COLUMN dst_ouser VARCHAR(64) NOT NULL DEFAULT '';
    ALTER TABLE acc ADD COLUMN dst_user VARCHAR(64) NOT NULL DEFAULT '';
    ALTER TABLE acc ADD COLUMN dst_domain VARCHAR(128) NOT NULL DEFAULT '';
    ALTER TABLE missed_calls ADD COLUMN src_user VARCHAR(64) NOT NULL DEFAULT '';
    ALTER TABLE missed_calls ADD COLUMN src_domain VARCHAR(128) NOT NULL DEFAULT '';
    ALTER TABLE missed_calls ADD COLUMN src_ip varchar(64) NOT NULL default '';
    ALTER TABLE missed_calls ADD COLUMN dst_ouser VARCHAR(64) NOT NULL DEFAULT '';
    ALTER TABLE missed_calls ADD COLUMN dst_user VARCHAR(64) NOT NULL DEFAULT '';
    ALTER TABLE missed_calls ADD COLUMN dst_domain VARCHAR(128) NOT NULL DEFAULT '';
    ```

[Kamailio]: https://www.kamailio.org/
[RTPProxy]: http://www.rtpproxy.org/
