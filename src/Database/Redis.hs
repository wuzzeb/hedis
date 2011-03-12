{-# LANGUAGE OverloadedStrings, TemplateHaskell, CPP #-}

module Database.Redis (
    module Database.Redis.Internal,
    module Database.Redis.Reply,
    module Database.Redis.PubSub,
    module Database.Redis.Types,
    -- * Commands
    -- ** Keys
    del, exists, expire, expireat, keys, move, persist, randomkey, rename,
    renamenx, sort, ttl, getType,
    -- ** Strings
    append, decr, decrby, get, getbit, getrange, getset, incr, incrby, mget,
    mset, msetnx, set, setbit, setex, setnx, setrange, strlen,
    -- ** Hashes
    hdel, hexists, hget, hgetall, hincrby, hkeys, hlen, hmget, hmset, hset,
    hsetnx, hvals,
    -- ** Other
    lrange, sunion, ping, flushall, lpush, sadd, zadd
) where

import Control.Applicative
import Data.ByteString (ByteString)
import Database.Redis.CommandTemplates
import Database.Redis.Internal
import Database.Redis.PubSub
import Database.Redis.Reply
import Database.Redis.Types

------------------------------------------------------------------------------
-- Redis commands
--

#define comment(cmd) Redis Command, see <http://redis.io/commands/cmd>


------------------------------------------------------------------------------
-- Keys
--
cmdVar intRT "del" "" "ks"
cmd boolRT "exists" "key"
cmd boolRT "expire" "key seconds"
cmd boolRT "expireat" "key timestamp"
cmd listRT "keys" "pattern"
cmd boolRT "move" "key db"
cmd boolRT "persist" "key"
cmd keyRT "randomkey" ""
cmd statusRT "rename" "key newkey"
cmd boolRT "renamenx" "key newkey"
-- TODO sort
sort :: ()
sort = undefined
cmd intRT "ttl" "key"
-- special handling: function name != command
getType :: RedisStatus a => ByteString -> Redis (Maybe a)
getType key = decodeStatus <$> sendRequest ["TYPE", key]


------------------------------------------------------------------------------
-- Strings
--
cmd intRT "append" "key value"
cmd intRT "decr" "key"
cmd intRT "decrby" "key decrement"
cmd valueRT "get" "key"
cmd intRT "getbit" "key offset"
cmd valueRT "getrange" "key start end"
cmd valueRT "getset" "key value"
cmd intRT "incr" "key"
cmd intRT "incrby" "key increment"
cmdVar listRT "mget" "" "ks"
cmdVar statusRT "mset" "" "keysvalues"
cmdVar boolRT "msetnx" "" "keysvalues"
cmd statusRT "set" "key value"
cmd intRT "setbit" "key offset value"
cmd statusRT "setex" "key seconds value"
cmd boolRT "setnx" "key value"
cmd intRT "setrange" "key offset value"
cmd intRT "strlen" "key"


------------------------------------------------------------------------------
-- Hashes
--
cmd boolRT "hdel" "key field"
cmd boolRT "hexists" "key field"
cmd valueRT "hget" "key field"
cmd hashRT "hgetall" "key"
cmd intRT "hincrby" "key field increment"
cmd setRT "hkeys" "key"
cmd intRT "hlen" "key"
cmdVar listRT "hmget" "key" "fields"
cmdVar statusRT "hmset" "key" "fieldsvalues"
cmd boolRT "hset" "key field value"
cmd boolRT "hsetnx" "key field value"
cmd setRT "hvals" "key"


------------------------------------------------------------------------------
-- Lists
--
cmd intRT "lpush" "key value"
{- |comment(lrange) -}
cmd listRT "lrange" "key start stop"


------------------------------------------------------------------------------
-- Sets
--
cmd boolRT "sadd" "key member"
{- |comment(sunion) -}
cmdVar setRT "sunion" "" "ks"


------------------------------------------------------------------------------
-- Sorted Sets
--
cmd boolRT "zadd" "key score member"


------------------------------------------------------------------------------
-- Pub/Sub
--


------------------------------------------------------------------------------
-- Transaction
--


------------------------------------------------------------------------------
-- Connection
--
{- |comment(ping) -}
cmd statusRT "ping" ""

------------------------------------------------------------------------------
-- Server
--
cmd statusRT "flushall" ""
