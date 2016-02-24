-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--
--
-- PostGIS - Spatial Types for PostgreSQL
-- http://postgis.net
-- Copyright 2016 Regina Obe
--
-- This is free software; you can redistribute and/or modify it under
-- the terms of the GNU General Public Licence. See the COPYING file.
--
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
-- This routine adds search_path to functions known to have issues
-- during restore.  Functions that call other postgis functions 
-- or spatial_ref_sys should be in here
-- These are functions that are called by restore process for purposes of
-- creating indexes, creating constraints, and creating materialized views
-- Also functions that are used in foreign tables 
-- that call other postgis functions.  Eventually all functions should be here
-- At that point we decide to add to all functions, 
-- this script should be autogenerated
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -



DO language plpgsql
$$
DECLARE param_postgis_schema text;
BEGIN
-- check if PostGIS is already installed
param_postgis_schema = (SELECT n.nspname from pg_extension e join pg_namespace n on e.extnamespace = n.oid WHERE extname = 'postgis');

-- if in middle install, it will be the current_schema or what was there already
param_postgis_schema = COALESCE(param_postgis_schema, current_schema());
EXECUTE 'set search_path TO ' || quote_ident(param_postgis_schema);

-- PostGIS geometry funcs
EXECUTE 'ALTER FUNCTION st_transform(geometry, integer) SET search_path=' || quote_ident(param_postgis_schema) || ';';

-- PostGIS raster funcs
EXECUTE 'ALTER FUNCTION _raster_constraint_pixel_types(raster) SET search_path=' || quote_ident(param_postgis_schema) || ';';
EXECUTE 'ALTER FUNCTION _raster_constraint_info_regular_blocking(name,name,name) SET search_path=' || quote_ident(param_postgis_schema) || ';';
END;
$$