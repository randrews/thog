#include "Tmx.h"
#include <stdlib.h>
#include <stdio.h>

extern "C" {
#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>

    int luaopen_tmx(lua_State *lua);
}

void pushLayers(lua_State*, Tmx::Map*);
void pushObjects(lua_State*, Tmx::Map*);

int open_tmx(lua_State *L){
    const char *fname = luaL_checkstring(L, 1);

    Tmx::Map *map = new Tmx::Map();
    map->ParseFile(fname);

    if (map->HasError()) {
        return luaL_error(L,
                          "Error %d: %s",
                          map->GetErrorCode(),
                          map->GetErrorText().c_str());
    }

    lua_newtable(L);

    lua_pushstring(L, "layers");
    pushLayers(L, map);
    lua_settable(L, -3);

    lua_pushstring(L, "objects");
    pushObjects(L, map);
    lua_settable(L, -3);

    delete map;
    return 1;
}

void pushLayers(lua_State *L, Tmx::Map *map){
    lua_newtable(L);
    int tbl = lua_gettop(L);

    // Iterate through the layers.
    for (int i = 0; i < map->GetNumLayers(); ++i) {
        lua_pushnumber(L, i+1);

        lua_newtable(L);
        const Tmx::Layer *layer = map->GetLayer(i);

        lua_pushstring(L, "name");
        lua_pushstring(L, layer->GetName().c_str());
        lua_settable(L, -3);

        lua_pushstring(L, "width");
        lua_pushnumber(L, layer->GetWidth());
        lua_settable(L, -3);

        lua_pushstring(L, "height");
        lua_pushnumber(L, layer->GetHeight());
        lua_settable(L, -3);

        for (int y = 0; y < layer->GetHeight(); ++y) {
            for (int x = 0; x < layer->GetWidth(); ++x) {
                lua_pushnumber(L, x+y*layer->GetWidth());
                lua_pushnumber(L, layer->GetTileGid(x, y));
                lua_settable(L, -3);
            }
        }

        lua_settable(L, tbl);
    }
}

void objectProperties(lua_State *L, const Tmx::PropertySet properties){
    lua_newtable(L);
    int prop_tbl = lua_gettop(L);

    std::map< std::string, std::string > list = properties.GetList();
    std::map< std::string, std::string >::iterator it;

    for(it = list.begin(); it!= list.end(); it++){
        lua_pushstring(L, (*it).first.c_str());
        lua_pushstring(L, (*it).second.c_str());
        lua_settable(L, prop_tbl);
    }
}

void objectTable(lua_State *L, const Tmx::Object *object){
    lua_newtable(L);
    int obj_tbl = lua_gettop(L);

    lua_pushstring(L, "name");
    lua_pushstring(L, object->GetName().c_str());
    lua_settable(L, obj_tbl);

    lua_pushstring(L, "type");
    lua_pushstring(L, object->GetType().c_str());
    lua_settable(L, obj_tbl);

    lua_pushstring(L, "x");
    lua_pushnumber(L, object->GetX());
    lua_settable(L, obj_tbl);

    lua_pushstring(L, "y");
    lua_pushnumber(L, object->GetY());
    lua_settable(L, obj_tbl);

    lua_pushstring(L, "width");
    lua_pushnumber(L, object->GetWidth());
    lua_settable(L, obj_tbl);

    lua_pushstring(L, "height");
    lua_pushnumber(L, object->GetHeight());
    lua_settable(L, obj_tbl);

    lua_pushstring(L, "properties");
    objectProperties(L, object->GetProperties());
    lua_settable(L, obj_tbl);
}

void objectGroupTable(lua_State *L, const Tmx::ObjectGroup *objectGroup){
    lua_newtable(L);
    int ogroup = lua_gettop(L);

    lua_pushstring(L, "name");
    lua_pushstring(L, objectGroup->GetName().c_str());
    lua_settable(L, ogroup);

    for (int j = 0; j < objectGroup->GetNumObjects(); ++j) {
        lua_pushnumber(L, j+1);
        objectTable(L, objectGroup->GetObject(j));
        lua_settable(L, ogroup);
    }
}

void pushObjects(lua_State *L, Tmx::Map *map){
    lua_newtable(L);
    int tbl = lua_gettop(L);

    for (int i = 0; i < map->GetNumObjectGroups(); ++i) {
        lua_pushnumber(L, i+1);
        objectGroupTable(L, map->GetObjectGroup(i));
        lua_settable(L, tbl);
    }
}

////////////////////////////////////////

luaL_Reg LUA_TMX[] = {
    {"open", open_tmx},
    {NULL, NULL}
};

int luaopen_tmx(lua_State *L) {
    luaL_openlib(L, "tmx", LUA_TMX, 0);

    return 0;
}
