-- Database generated with pgModeler (PostgreSQL Database Modeler).
-- pgModeler version: 1.0.0-alpha
-- PostgreSQL version: 14.0
-- Project Site: pgmodeler.io
-- Model Author: Jedson Gabriel
-- object: smartfarmer | type: ROLE --
-- DROP ROLE IF EXISTS smartfarmer;
-- CREATE ROLE smartfarmer WITH 
-- 	CREATEDB
-- 	LOGIN
-- 	ENCRYPTED PASSWORD 'labiot2020.';
-- ddl-end --


-- Database creation must be performed outside a multi lined SQL file. 
-- These commands were put in this file only as a convenience.
-- 
-- object: "SmartFarm" | type: DATABASE --
-- DROP DATABASE IF EXISTS "SmartFarm";
-- CREATE DATABASE "SmartFarm"
-- 	ENCODING = 'UTF8'
-- 	OWNER = smartfarmer;
-- ddl-end --


-- object: public."Station" | type: TABLE --
-- DROP TABLE IF EXISTS public."Station" CASCADE;
CREATE TABLE public."Station" (
	id serial NOT NULL,
	code integer NOT NULL,
	description text,
	"creationTS" timestamp with time zone DEFAULT now(),
	active boolean NOT NULL DEFAULT true,
	"deactivationTS" timestamp with time zone,
	"id_StationModel" integer,
	CONSTRAINT "Station_pk" PRIMARY KEY (id),
	CONSTRAINT "Station_Code_Unique" UNIQUE (code)
);
-- ddl-end --
ALTER TABLE public."Station" OWNER TO smartfarmer;
-- ddl-end --

-- object: public."StationModel" | type: TABLE --
-- DROP TABLE IF EXISTS public."StationModel" CASCADE;
CREATE TABLE public."StationModel" (
	id serial NOT NULL,
	name text,
	upc integer,
	serial bigint,
	description text,
	CONSTRAINT "StationModel_pk" PRIMARY KEY (id)
);
-- ddl-end --
ALTER TABLE public."StationModel" OWNER TO smartfarmer;
-- ddl-end --

-- object: "StationModel_fk" | type: CONSTRAINT --
-- ALTER TABLE public."Station" DROP CONSTRAINT IF EXISTS "StationModel_fk" CASCADE;
ALTER TABLE public."Station" ADD CONSTRAINT "StationModel_fk" FOREIGN KEY ("id_StationModel")
REFERENCES public."StationModel" (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: public."Station_Sensor" | type: TABLE --
-- DROP TABLE IF EXISTS public."Station_Sensor" CASCADE;
CREATE TABLE public."Station_Sensor" (
	id serial NOT NULL,
	"id_StationModel" integer,
	"id_Sensor" integer,
	CONSTRAINT "StationSensor_pk" PRIMARY KEY (id)
);
-- ddl-end --
ALTER TABLE public."Station_Sensor" OWNER TO smartfarmer;
-- ddl-end --

-- object: public."Sensor" | type: TABLE --
-- DROP TABLE IF EXISTS public."Sensor" CASCADE;
CREATE TABLE public."Sensor" (
	id serial NOT NULL,
	code integer NOT NULL,
	serial integer,
	"SKU" text,
	lifespan interval,
	"id_Manufacturer" integer,
	CONSTRAINT "Sensor_pk" PRIMARY KEY (id),
	CONSTRAINT "Sensor_Code_Unique" UNIQUE (code)
);
-- ddl-end --
COMMENT ON COLUMN public."Sensor".code IS E'The self-reporting code given by the stations sensors';
-- ddl-end --
ALTER TABLE public."Sensor" OWNER TO smartfarmer;
-- ddl-end --

-- object: "StationModel_fk" | type: CONSTRAINT --
-- ALTER TABLE public."Station_Sensor" DROP CONSTRAINT IF EXISTS "StationModel_fk" CASCADE;
ALTER TABLE public."Station_Sensor" ADD CONSTRAINT "StationModel_fk" FOREIGN KEY ("id_StationModel")
REFERENCES public."StationModel" (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: "Sensor_fk" | type: CONSTRAINT --
-- ALTER TABLE public."Station_Sensor" DROP CONSTRAINT IF EXISTS "Sensor_fk" CASCADE;
ALTER TABLE public."Station_Sensor" ADD CONSTRAINT "Sensor_fk" FOREIGN KEY ("id_Sensor")
REFERENCES public."Sensor" (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: public."MeasurementUnit" | type: TABLE --
-- DROP TABLE IF EXISTS public."MeasurementUnit" CASCADE;
CREATE TABLE public."MeasurementUnit" (
	id serial NOT NULL,
	code integer NOT NULL,
	name text,
	description text,
	CONSTRAINT "MeasurementUnit_pk" PRIMARY KEY (id),
	CONSTRAINT "MeasurementUnit_Code_Unique" UNIQUE (code)
);
-- ddl-end --
ALTER TABLE public."MeasurementUnit" OWNER TO smartfarmer;
-- ddl-end --

-- object: public."MeasurementUnit_Sensor" | type: TABLE --
-- DROP TABLE IF EXISTS public."MeasurementUnit_Sensor" CASCADE;
CREATE TABLE public."MeasurementUnit_Sensor" (
	id serial NOT NULL,
	"id_MeasurementUnit" integer,
	"id_SensorMeasurementConversion" integer,
	precision double precision,
	"minValue" double precision,
	"maxValue" double precision,
	"id_Sensor" integer,
	CONSTRAINT "MeasurementUnit_Sensor_pk" PRIMARY KEY (id)
);
-- ddl-end --
COMMENT ON COLUMN public."MeasurementUnit_Sensor".precision IS E'Precision of the sensor measurement for this unit';
-- ddl-end --
COMMENT ON COLUMN public."MeasurementUnit_Sensor"."minValue" IS E'Minimum value the sensor can report';
-- ddl-end --
COMMENT ON COLUMN public."MeasurementUnit_Sensor"."maxValue" IS E'Maximum value the sensor can report';
-- ddl-end --
ALTER TABLE public."MeasurementUnit_Sensor" OWNER TO smartfarmer;
-- ddl-end --

-- object: "MeasurementUnit_fk" | type: CONSTRAINT --
-- ALTER TABLE public."MeasurementUnit_Sensor" DROP CONSTRAINT IF EXISTS "MeasurementUnit_fk" CASCADE;
ALTER TABLE public."MeasurementUnit_Sensor" ADD CONSTRAINT "MeasurementUnit_fk" FOREIGN KEY ("id_MeasurementUnit")
REFERENCES public."MeasurementUnit" (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: "Sensor_fk" | type: CONSTRAINT --
-- ALTER TABLE public."MeasurementUnit_Sensor" DROP CONSTRAINT IF EXISTS "Sensor_fk" CASCADE;
ALTER TABLE public."MeasurementUnit_Sensor" ADD CONSTRAINT "Sensor_fk" FOREIGN KEY ("id_Sensor")
REFERENCES public."Sensor" (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: public."SensorMeasurementConversion" | type: TABLE --
-- DROP TABLE IF EXISTS public."SensorMeasurementConversion" CASCADE;
CREATE TABLE public."SensorMeasurementConversion" (
	id serial NOT NULL,
	equation text,
	description text,
	CONSTRAINT "SensorMeasurementConversion_pk" PRIMARY KEY (id)
);
-- ddl-end --
ALTER TABLE public."SensorMeasurementConversion" OWNER TO smartfarmer;
-- ddl-end --

-- object: "SensorMeasurementConversion_fk" | type: CONSTRAINT --
-- ALTER TABLE public."MeasurementUnit_Sensor" DROP CONSTRAINT IF EXISTS "SensorMeasurementConversion_fk" CASCADE;
ALTER TABLE public."MeasurementUnit_Sensor" ADD CONSTRAINT "SensorMeasurementConversion_fk" FOREIGN KEY ("id_SensorMeasurementConversion")
REFERENCES public."SensorMeasurementConversion" (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: public."Manufacturer" | type: TABLE --
-- DROP TABLE IF EXISTS public."Manufacturer" CASCADE;
CREATE TABLE public."Manufacturer" (
	id serial NOT NULL,
	name text,
	"id_Country" integer NOT NULL,
	CONSTRAINT "Manufacturer_pk" PRIMARY KEY (id)
);
-- ddl-end --
ALTER TABLE public."Manufacturer" OWNER TO smartfarmer;
-- ddl-end --

-- object: "Manufacturer_fk" | type: CONSTRAINT --
-- ALTER TABLE public."Sensor" DROP CONSTRAINT IF EXISTS "Manufacturer_fk" CASCADE;
ALTER TABLE public."Sensor" ADD CONSTRAINT "Manufacturer_fk" FOREIGN KEY ("id_Manufacturer")
REFERENCES public."Manufacturer" (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: public."MeasuredData" | type: TABLE --
-- DROP TABLE IF EXISTS public."MeasuredData" CASCADE;
CREATE TABLE public."MeasuredData" (
	id serial NOT NULL,
	"rawValue" double precision NOT NULL,
	"convertedValue" double precision,
	"timestamp" timestamp with time zone,
	code integer NOT NULL,
	CONSTRAINT "MeasuredData_pk" PRIMARY KEY (id)
);
-- ddl-end --
ALTER TABLE public."MeasuredData" OWNER TO smartfarmer;
-- ddl-end --

-- object: public."TimeSeries" | type: TABLE --
-- DROP TABLE IF EXISTS public."TimeSeries" CASCADE;
CREATE TABLE public."TimeSeries" (
	id serial NOT NULL,
	"startTS" timestamp with time zone NOT NULL,
	"endTS" timestamp with time zone NOT NULL,
	count integer,
	sum double precision,
	average double precision,
	min double precision,
	max double precision,
	"id_TimeSeriesInterval" integer,
	CONSTRAINT "TimeSeries_pk" PRIMARY KEY (id)
);
-- ddl-end --
ALTER TABLE public."TimeSeries" OWNER TO smartfarmer;
-- ddl-end --

-- object: public."TimeSeriesInterval" | type: TABLE --
-- DROP TABLE IF EXISTS public."TimeSeriesInterval" CASCADE;
CREATE TABLE public."TimeSeriesInterval" (
	id serial NOT NULL,
	description text NOT NULL,
	CONSTRAINT "TimeSeriesInterval_pk" PRIMARY KEY (id)
);
-- ddl-end --
ALTER TABLE public."TimeSeriesInterval" OWNER TO smartfarmer;
-- ddl-end --

-- object: public."TimeSeries_MeasureData" | type: TABLE --
-- DROP TABLE IF EXISTS public."TimeSeries_MeasureData" CASCADE;
CREATE TABLE public."TimeSeries_MeasureData" (
	id serial NOT NULL,
	"id_TimeSeries" integer,
	"id_MeasuredData" integer,
	CONSTRAINT "TimeSeries_MeasureData_pk" PRIMARY KEY (id)
);
-- ddl-end --
COMMENT ON TABLE public."TimeSeries_MeasureData" IS E'This table stores the data utilized to calculate the time series';
-- ddl-end --
ALTER TABLE public."TimeSeries_MeasureData" OWNER TO smartfarmer;
-- ddl-end --

-- object: "TimeSeries_fk" | type: CONSTRAINT --
-- ALTER TABLE public."TimeSeries_MeasureData" DROP CONSTRAINT IF EXISTS "TimeSeries_fk" CASCADE;
ALTER TABLE public."TimeSeries_MeasureData" ADD CONSTRAINT "TimeSeries_fk" FOREIGN KEY ("id_TimeSeries")
REFERENCES public."TimeSeries" (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: "MeasuredData_fk" | type: CONSTRAINT --
-- ALTER TABLE public."TimeSeries_MeasureData" DROP CONSTRAINT IF EXISTS "MeasuredData_fk" CASCADE;
ALTER TABLE public."TimeSeries_MeasureData" ADD CONSTRAINT "MeasuredData_fk" FOREIGN KEY ("id_MeasuredData")
REFERENCES public."MeasuredData" (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: "TimeSeriesInterval_fk" | type: CONSTRAINT --
-- ALTER TABLE public."TimeSeries" DROP CONSTRAINT IF EXISTS "TimeSeriesInterval_fk" CASCADE;
ALTER TABLE public."TimeSeries" ADD CONSTRAINT "TimeSeriesInterval_fk" FOREIGN KEY ("id_TimeSeriesInterval")
REFERENCES public."TimeSeriesInterval" (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: public."Country" | type: TABLE --
-- DROP TABLE IF EXISTS public."Country" CASCADE;
CREATE TABLE public."Country" (
	id serial NOT NULL,
	name text NOT NULL,
	code text NOT NULL,
	CONSTRAINT country_pk PRIMARY KEY (id),
	CONSTRAINT "Country_Code_Unique" UNIQUE (code)
);
-- ddl-end --
ALTER TABLE public."Country" OWNER TO smartfarmer;
-- ddl-end --

-- object: "Country_fk" | type: CONSTRAINT --
-- ALTER TABLE public."Manufacturer" DROP CONSTRAINT IF EXISTS "Country_fk" CASCADE;
ALTER TABLE public."Manufacturer" ADD CONSTRAINT "Country_fk" FOREIGN KEY ("id_Country")
REFERENCES public."Country" (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: public."Station_Sensor_MeasurementUnit" | type: TABLE --
-- DROP TABLE IF EXISTS public."Station_Sensor_MeasurementUnit" CASCADE;
CREATE TABLE public."Station_Sensor_MeasurementUnit" (
	id serial NOT NULL,
	code integer NOT NULL,
	"id_Station" integer,
	"id_MeasurementUnit" integer,
	"id_Sensor" integer,
	CONSTRAINT "MeasuredData_Pivot_pk" PRIMARY KEY (id),
	CONSTRAINT "MeasuredData_Pivot_Code_Unique" UNIQUE (code)
);
-- ddl-end --
ALTER TABLE public."Station_Sensor_MeasurementUnit" OWNER TO smartfarmer;
-- ddl-end --

-- object: "Station_fk" | type: CONSTRAINT --
-- ALTER TABLE public."Station_Sensor_MeasurementUnit" DROP CONSTRAINT IF EXISTS "Station_fk" CASCADE;
ALTER TABLE public."Station_Sensor_MeasurementUnit" ADD CONSTRAINT "Station_fk" FOREIGN KEY ("id_Station")
REFERENCES public."Station" (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: "MeasurementUnit_fk" | type: CONSTRAINT --
-- ALTER TABLE public."Station_Sensor_MeasurementUnit" DROP CONSTRAINT IF EXISTS "MeasurementUnit_fk" CASCADE;
ALTER TABLE public."Station_Sensor_MeasurementUnit" ADD CONSTRAINT "MeasurementUnit_fk" FOREIGN KEY ("id_MeasurementUnit")
REFERENCES public."MeasurementUnit" (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: "Sensor_fk" | type: CONSTRAINT --
-- ALTER TABLE public."Station_Sensor_MeasurementUnit" DROP CONSTRAINT IF EXISTS "Sensor_fk" CASCADE;
ALTER TABLE public."Station_Sensor_MeasurementUnit" ADD CONSTRAINT "Sensor_fk" FOREIGN KEY ("id_Sensor")
REFERENCES public."Sensor" (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: "Station_Sensor_MeasurementUnit_fk" | type: CONSTRAINT --
-- ALTER TABLE public."MeasuredData" DROP CONSTRAINT IF EXISTS "Station_Sensor_MeasurementUnit_fk" CASCADE;
ALTER TABLE public."MeasuredData" ADD CONSTRAINT "Station_Sensor_MeasurementUnit_fk" FOREIGN KEY (code)
REFERENCES public."Station_Sensor_MeasurementUnit" (code) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --


