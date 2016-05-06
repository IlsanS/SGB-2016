BEGIN
dbms_network_acl_admin.create_acl (
acl => 'imagetmdb.xml',
description => '...',
principal => 'CB',
is_grant => true,
privilege => 'connect',
start_date => null,
end_date => null
);

DBMS_NETWORK_ACL_ADMIN.ADD_PRIVILEGE(acl => 'imagetmdb.xml',
principal => 'CB',
is_grant => true,
privilege => 'resolve');

DBMS_NETWORK_ACL_ADMIN.ASSIGN_ACL(acl => 'imagetmdb.xml',
host => 'image.tmdb.org');

END;
/
COMMIT;