CREATE $<TARGET_FILE:mysqlserver>
ADDLIB $<TARGET_FILE:dbug>
ADDLIB $<TARGET_FILE:strings>
ADDLIB $<TARGET_FILE:vio>
ADDLIB $<TARGET_FILE:csv_embedded>
ADDLIB $<TARGET_FILE:heap_embedded>
ADDLIB $<TARGET_FILE:innobase_embedded>
ADDLIB $<TARGET_FILE:aria_embedded>
ADDLIB $<TARGET_FILE:mysys>
ADDLIB $<TARGET_FILE:mysys_ssl>
ADDLIB $<TARGET_FILE:myisam_embedded>
ADDLIB $<TARGET_FILE:myisammrg_embedded>
ADDLIB $<TARGET_FILE:perfschema_embedded>
ADDLIB $<TARGET_FILE:sequence_embedded>
ADDLIB $<TARGET_FILE:auth_socket_embedded>
ADDLIB $<TARGET_FILE:feedback_embedded>
ADDLIB $<TARGET_FILE:type_geom_embedded>
ADDLIB $<TARGET_FILE:type_inet_embedded>
ADDLIB $<TARGET_FILE:user_variables_embedded>
ADDLIB $<TARGET_FILE:userstat_embedded>
ADDLIB $<TARGET_FILE:partition_embedded>
ADDLIB $<TARGET_FILE:sql_sequence_embedded>
ADDLIB $<TARGET_FILE:sql_embedded>

SAVE
END
