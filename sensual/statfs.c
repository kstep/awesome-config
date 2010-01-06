#include <sys/vfs.h>

#include <lua.h>
#include <lauxlib.h>

#define luaA_settable(L, tableidx, index, luatype, value) \
	lua_push##luatype (L, value); \
	lua_setfield(L, tableidx, index)

#define luaA_isettable(L, tableidx, index, luatype, value) \
	lua_push##luatype (L, value); \
	lua_rawseti(L, tableidx, index)

static int luaA_statfs_statfs(lua_State *L, struct statfs *stfs) {
	lua_createtable(L, 0, 20);

	luaA_settable(L, -2, "type", number, stfs->f_type);
	luaA_settable(L, -2, "bsize", number, stfs->f_bsize);
	luaA_settable(L, -2, "blocks", number, stfs->f_blocks);
	luaA_settable(L, -2, "bfree", number, stfs->f_bfree);
	luaA_settable(L, -2, "bavail", number, stfs->f_bavail);
	luaA_settable(L, -2, "files", number, stfs->f_files);
	luaA_settable(L, -2, "ffree", number, stfs->f_ffree);
	luaA_settable(L, -2, "namelen", number, stfs->f_namelen);

	/*lua_createtable(L, 2, 0);
	luaA_isettable(L, -2, 1, number, stfs->f_fsid.val[0]);
	luaA_isettable(L, -2, 2, number, stfs->f_fsid.val[1]);
	lua_setfield(L, -2, "fsid");*/

	return 1;
}

static int luaA_statfs_getstatfs(lua_State *L) {
	const char* mntpname = luaL_checkstring(L, 1);
	struct statfs stfs;
	if (statfs(mntpname, &stfs))
		return 0;

	return luaA_statfs_statfs(L, &stfs);
}

static const luaL_reg statfs_methods[] = {
	{"getstat", luaA_statfs_getstatfs},
	{NULL, NULL}
};

LUALIB_API int luaopen_statfs(lua_State *L) {

	luaL_register(L, "statfs", statfs_methods);
	lua_pushliteral(L, "version");
	lua_pushliteral(L, "statfs library for lua");
	lua_settable(L, -3);
	return 1;
}

