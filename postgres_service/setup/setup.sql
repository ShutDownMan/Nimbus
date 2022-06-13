-- Database generated with pgModeler (PostgreSQL Database Modeler).
-- pgModeler version: 1.0.0-alpha
-- PostgreSQL version: 14.0
-- Project Site: pgmodeler.io
-- Model Author: Jedson Gabriel

SET check_function_bodies = false;
-- ddl-end --

-- object: public."Station" | type: TABLE --
-- DROP TABLE IF EXISTS public."Station" CASCADE;
CREATE TABLE public."Station" (
);
-- ddl-end --

-- object: id | type: COLUMN --
-- ALTER TABLE public."Station" DROP COLUMN IF EXISTS id CASCADE;
ALTER TABLE public."Station" ADD COLUMN id serial NOT NULL;
-- ddl-end --


-- object: code | type: COLUMN --
-- ALTER TABLE public."Station" DROP COLUMN IF EXISTS code CASCADE;
ALTER TABLE public."Station" ADD COLUMN code char(12) NOT NULL;
-- ddl-end --


-- object: description | type: COLUMN --
-- ALTER TABLE public."Station" DROP COLUMN IF EXISTS description CASCADE;
ALTER TABLE public."Station" ADD COLUMN description text;
-- ddl-end --


-- object: "creationTS" | type: COLUMN --
-- ALTER TABLE public."Station" DROP COLUMN IF EXISTS "creationTS" CASCADE;
ALTER TABLE public."Station" ADD COLUMN "creationTS" timestamp with time zone DEFAULT now();
-- ddl-end --


-- object: active | type: COLUMN --
-- ALTER TABLE public."Station" DROP COLUMN IF EXISTS active CASCADE;
ALTER TABLE public."Station" ADD COLUMN active boolean NOT NULL DEFAULT true;
-- ddl-end --


-- object: "deactivationTS" | type: COLUMN --
-- ALTER TABLE public."Station" DROP COLUMN IF EXISTS "deactivationTS" CASCADE;
ALTER TABLE public."Station" ADD COLUMN "deactivationTS" timestamp with time zone;
-- ddl-end --


-- object: "id_StationModel" | type: COLUMN --
-- ALTER TABLE public."Station" DROP COLUMN IF EXISTS "id_StationModel" CASCADE;
ALTER TABLE public."Station" ADD COLUMN "id_StationModel" integer;
-- ddl-end --



-- object: "Station_pk" | type: CONSTRAINT --
-- ALTER TABLE public."Station" DROP CONSTRAINT IF EXISTS "Station_pk" CASCADE;
ALTER TABLE public."Station" ADD CONSTRAINT "Station_pk" PRIMARY KEY (id);
-- ddl-end --

-- object: "Station_Code_Unique" | type: CONSTRAINT --
-- ALTER TABLE public."Station" DROP CONSTRAINT IF EXISTS "Station_Code_Unique" CASCADE;
ALTER TABLE public."Station" ADD CONSTRAINT "Station_Code_Unique" UNIQUE (code);
-- ddl-end --

ALTER TABLE public."Station" OWNER TO smartfarmer;
-- ddl-end --

-- object: public."StationModel" | type: TABLE --
-- DROP TABLE IF EXISTS public."StationModel" CASCADE;
CREATE TABLE public."StationModel" (
);
-- ddl-end --

-- object: id | type: COLUMN --
-- ALTER TABLE public."StationModel" DROP COLUMN IF EXISTS id CASCADE;
ALTER TABLE public."StationModel" ADD COLUMN id serial NOT NULL;
-- ddl-end --


-- object: name | type: COLUMN --
-- ALTER TABLE public."StationModel" DROP COLUMN IF EXISTS name CASCADE;
ALTER TABLE public."StationModel" ADD COLUMN name text;
-- ddl-end --


-- object: upc | type: COLUMN --
-- ALTER TABLE public."StationModel" DROP COLUMN IF EXISTS upc CASCADE;
ALTER TABLE public."StationModel" ADD COLUMN upc integer;
-- ddl-end --


-- object: serial | type: COLUMN --
-- ALTER TABLE public."StationModel" DROP COLUMN IF EXISTS serial CASCADE;
ALTER TABLE public."StationModel" ADD COLUMN serial bigint;
-- ddl-end --


-- object: description | type: COLUMN --
-- ALTER TABLE public."StationModel" DROP COLUMN IF EXISTS description CASCADE;
ALTER TABLE public."StationModel" ADD COLUMN description text;
-- ddl-end --



-- object: "StationModel_pk" | type: CONSTRAINT --
-- ALTER TABLE public."StationModel" DROP CONSTRAINT IF EXISTS "StationModel_pk" CASCADE;
ALTER TABLE public."StationModel" ADD CONSTRAINT "StationModel_pk" PRIMARY KEY (id);
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
);
-- ddl-end --

-- object: id | type: COLUMN --
-- ALTER TABLE public."Station_Sensor" DROP COLUMN IF EXISTS id CASCADE;
ALTER TABLE public."Station_Sensor" ADD COLUMN id serial NOT NULL;
-- ddl-end --


-- object: "id_Sensor" | type: COLUMN --
-- ALTER TABLE public."Station_Sensor" DROP COLUMN IF EXISTS "id_Sensor" CASCADE;
ALTER TABLE public."Station_Sensor" ADD COLUMN "id_Sensor" integer;
-- ddl-end --


-- object: "id_Station" | type: COLUMN --
-- ALTER TABLE public."Station_Sensor" DROP COLUMN IF EXISTS "id_Station" CASCADE;
ALTER TABLE public."Station_Sensor" ADD COLUMN "id_Station" integer;
-- ddl-end --



-- object: "StationSensor_pk" | type: CONSTRAINT --
-- ALTER TABLE public."Station_Sensor" DROP CONSTRAINT IF EXISTS "StationSensor_pk" CASCADE;
ALTER TABLE public."Station_Sensor" ADD CONSTRAINT "StationSensor_pk" PRIMARY KEY (id);
-- ddl-end --

ALTER TABLE public."Station_Sensor" OWNER TO smartfarmer;
-- ddl-end --

-- object: public."Sensor" | type: TABLE --
-- DROP TABLE IF EXISTS public."Sensor" CASCADE;
CREATE TABLE public."Sensor" (
);
-- ddl-end --

-- object: id | type: COLUMN --
-- ALTER TABLE public."Sensor" DROP COLUMN IF EXISTS id CASCADE;
ALTER TABLE public."Sensor" ADD COLUMN id serial NOT NULL;
-- ddl-end --


-- object: code | type: COLUMN --
-- ALTER TABLE public."Sensor" DROP COLUMN IF EXISTS code CASCADE;
ALTER TABLE public."Sensor" ADD COLUMN code char(2) NOT NULL;
-- ddl-end --

COMMENT ON COLUMN public."Sensor".code IS E'The self-reporting code given by the stations sensors';
-- ddl-end --


-- object: serial | type: COLUMN --
-- ALTER TABLE public."Sensor" DROP COLUMN IF EXISTS serial CASCADE;
ALTER TABLE public."Sensor" ADD COLUMN serial integer;
-- ddl-end --


-- object: "SKU" | type: COLUMN --
-- ALTER TABLE public."Sensor" DROP COLUMN IF EXISTS "SKU" CASCADE;
ALTER TABLE public."Sensor" ADD COLUMN "SKU" text;
-- ddl-end --


-- object: lifespan | type: COLUMN --
-- ALTER TABLE public."Sensor" DROP COLUMN IF EXISTS lifespan CASCADE;
ALTER TABLE public."Sensor" ADD COLUMN lifespan interval;
-- ddl-end --


-- object: "id_Manufacturer" | type: COLUMN --
-- ALTER TABLE public."Sensor" DROP COLUMN IF EXISTS "id_Manufacturer" CASCADE;
ALTER TABLE public."Sensor" ADD COLUMN "id_Manufacturer" integer;
-- ddl-end --



-- object: "Sensor_pk" | type: CONSTRAINT --
-- ALTER TABLE public."Sensor" DROP CONSTRAINT IF EXISTS "Sensor_pk" CASCADE;
ALTER TABLE public."Sensor" ADD CONSTRAINT "Sensor_pk" PRIMARY KEY (id);
-- ddl-end --

-- object: "Sensor_Code_Unique" | type: CONSTRAINT --
-- ALTER TABLE public."Sensor" DROP CONSTRAINT IF EXISTS "Sensor_Code_Unique" CASCADE;
ALTER TABLE public."Sensor" ADD CONSTRAINT "Sensor_Code_Unique" UNIQUE (code);
-- ddl-end --

ALTER TABLE public."Sensor" OWNER TO smartfarmer;
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
);
-- ddl-end --

-- object: id | type: COLUMN --
-- ALTER TABLE public."MeasurementUnit" DROP COLUMN IF EXISTS id CASCADE;
ALTER TABLE public."MeasurementUnit" ADD COLUMN id serial NOT NULL;
-- ddl-end --


-- object: code | type: COLUMN --
-- ALTER TABLE public."MeasurementUnit" DROP COLUMN IF EXISTS code CASCADE;
ALTER TABLE public."MeasurementUnit" ADD COLUMN code char(2) NOT NULL;
-- ddl-end --


-- object: name | type: COLUMN --
-- ALTER TABLE public."MeasurementUnit" DROP COLUMN IF EXISTS name CASCADE;
ALTER TABLE public."MeasurementUnit" ADD COLUMN name text;
-- ddl-end --


-- object: description | type: COLUMN --
-- ALTER TABLE public."MeasurementUnit" DROP COLUMN IF EXISTS description CASCADE;
ALTER TABLE public."MeasurementUnit" ADD COLUMN description text;
-- ddl-end --



-- object: "MeasurementUnit_pk" | type: CONSTRAINT --
-- ALTER TABLE public."MeasurementUnit" DROP CONSTRAINT IF EXISTS "MeasurementUnit_pk" CASCADE;
ALTER TABLE public."MeasurementUnit" ADD CONSTRAINT "MeasurementUnit_pk" PRIMARY KEY (id);
-- ddl-end --

-- object: "MeasurementUnit_Code_Unique" | type: CONSTRAINT --
-- ALTER TABLE public."MeasurementUnit" DROP CONSTRAINT IF EXISTS "MeasurementUnit_Code_Unique" CASCADE;
ALTER TABLE public."MeasurementUnit" ADD CONSTRAINT "MeasurementUnit_Code_Unique" UNIQUE (code);
-- ddl-end --

ALTER TABLE public."MeasurementUnit" OWNER TO smartfarmer;
-- ddl-end --

-- object: public."Sensor_MeasurementUnit" | type: TABLE --
-- DROP TABLE IF EXISTS public."Sensor_MeasurementUnit" CASCADE;
CREATE TABLE public."Sensor_MeasurementUnit" (
);
-- ddl-end --

-- object: id | type: COLUMN --
-- ALTER TABLE public."Sensor_MeasurementUnit" DROP COLUMN IF EXISTS id CASCADE;
ALTER TABLE public."Sensor_MeasurementUnit" ADD COLUMN id serial NOT NULL;
-- ddl-end --


-- object: precision | type: COLUMN --
-- ALTER TABLE public."Sensor_MeasurementUnit" DROP COLUMN IF EXISTS precision CASCADE;
ALTER TABLE public."Sensor_MeasurementUnit" ADD COLUMN precision double precision;
-- ddl-end --

COMMENT ON COLUMN public."Sensor_MeasurementUnit".precision IS E'Precision of the sensor measurement for this unit';
-- ddl-end --


-- object: "minValue" | type: COLUMN --
-- ALTER TABLE public."Sensor_MeasurementUnit" DROP COLUMN IF EXISTS "minValue" CASCADE;
ALTER TABLE public."Sensor_MeasurementUnit" ADD COLUMN "minValue" double precision;
-- ddl-end --

COMMENT ON COLUMN public."Sensor_MeasurementUnit"."minValue" IS E'Minimum value the sensor can report';
-- ddl-end --


-- object: "maxValue" | type: COLUMN --
-- ALTER TABLE public."Sensor_MeasurementUnit" DROP COLUMN IF EXISTS "maxValue" CASCADE;
ALTER TABLE public."Sensor_MeasurementUnit" ADD COLUMN "maxValue" double precision;
-- ddl-end --

COMMENT ON COLUMN public."Sensor_MeasurementUnit"."maxValue" IS E'Maximum value the sensor can report';
-- ddl-end --


-- object: "id_Sensor" | type: COLUMN --
-- ALTER TABLE public."Sensor_MeasurementUnit" DROP COLUMN IF EXISTS "id_Sensor" CASCADE;
ALTER TABLE public."Sensor_MeasurementUnit" ADD COLUMN "id_Sensor" integer;
-- ddl-end --


-- object: "id_MeasurementUnit" | type: COLUMN --
-- ALTER TABLE public."Sensor_MeasurementUnit" DROP COLUMN IF EXISTS "id_MeasurementUnit" CASCADE;
ALTER TABLE public."Sensor_MeasurementUnit" ADD COLUMN "id_MeasurementUnit" integer;
-- ddl-end --


-- object: "id_SensorMeasurementConversion" | type: COLUMN --
-- ALTER TABLE public."Sensor_MeasurementUnit" DROP COLUMN IF EXISTS "id_SensorMeasurementConversion" CASCADE;
ALTER TABLE public."Sensor_MeasurementUnit" ADD COLUMN "id_SensorMeasurementConversion" integer;
-- ddl-end --



-- object: "MeasurementUnit_Sensor_pk" | type: CONSTRAINT --
-- ALTER TABLE public."Sensor_MeasurementUnit" DROP CONSTRAINT IF EXISTS "MeasurementUnit_Sensor_pk" CASCADE;
ALTER TABLE public."Sensor_MeasurementUnit" ADD CONSTRAINT "MeasurementUnit_Sensor_pk" PRIMARY KEY (id);
-- ddl-end --

ALTER TABLE public."Sensor_MeasurementUnit" OWNER TO smartfarmer;
-- ddl-end --

-- object: "MeasurementUnit_fk" | type: CONSTRAINT --
-- ALTER TABLE public."Sensor_MeasurementUnit" DROP CONSTRAINT IF EXISTS "MeasurementUnit_fk" CASCADE;
ALTER TABLE public."Sensor_MeasurementUnit" ADD CONSTRAINT "MeasurementUnit_fk" FOREIGN KEY ("id_MeasurementUnit")
REFERENCES public."MeasurementUnit" (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: "Sensor_fk" | type: CONSTRAINT --
-- ALTER TABLE public."Sensor_MeasurementUnit" DROP CONSTRAINT IF EXISTS "Sensor_fk" CASCADE;
ALTER TABLE public."Sensor_MeasurementUnit" ADD CONSTRAINT "Sensor_fk" FOREIGN KEY ("id_Sensor")
REFERENCES public."Sensor" (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: public."SensorMeasurementConversion" | type: TABLE --
-- DROP TABLE IF EXISTS public."SensorMeasurementConversion" CASCADE;
CREATE TABLE public."SensorMeasurementConversion" (
);
-- ddl-end --

-- object: id | type: COLUMN --
-- ALTER TABLE public."SensorMeasurementConversion" DROP COLUMN IF EXISTS id CASCADE;
ALTER TABLE public."SensorMeasurementConversion" ADD COLUMN id serial NOT NULL;
-- ddl-end --


-- object: equation | type: COLUMN --
-- ALTER TABLE public."SensorMeasurementConversion" DROP COLUMN IF EXISTS equation CASCADE;
ALTER TABLE public."SensorMeasurementConversion" ADD COLUMN equation text;
-- ddl-end --


-- object: description | type: COLUMN --
-- ALTER TABLE public."SensorMeasurementConversion" DROP COLUMN IF EXISTS description CASCADE;
ALTER TABLE public."SensorMeasurementConversion" ADD COLUMN description text;
-- ddl-end --



-- object: "SensorMeasurementConversion_pk" | type: CONSTRAINT --
-- ALTER TABLE public."SensorMeasurementConversion" DROP CONSTRAINT IF EXISTS "SensorMeasurementConversion_pk" CASCADE;
ALTER TABLE public."SensorMeasurementConversion" ADD CONSTRAINT "SensorMeasurementConversion_pk" PRIMARY KEY (id);
-- ddl-end --

ALTER TABLE public."SensorMeasurementConversion" OWNER TO smartfarmer;
-- ddl-end --

-- object: "SensorMeasurementConversion_fk" | type: CONSTRAINT --
-- ALTER TABLE public."Sensor_MeasurementUnit" DROP CONSTRAINT IF EXISTS "SensorMeasurementConversion_fk" CASCADE;
ALTER TABLE public."Sensor_MeasurementUnit" ADD CONSTRAINT "SensorMeasurementConversion_fk" FOREIGN KEY ("id_SensorMeasurementConversion")
REFERENCES public."SensorMeasurementConversion" (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: public."Manufacturer" | type: TABLE --
-- DROP TABLE IF EXISTS public."Manufacturer" CASCADE;
CREATE TABLE public."Manufacturer" (
);
-- ddl-end --

-- object: id | type: COLUMN --
-- ALTER TABLE public."Manufacturer" DROP COLUMN IF EXISTS id CASCADE;
ALTER TABLE public."Manufacturer" ADD COLUMN id serial NOT NULL;
-- ddl-end --


-- object: name | type: COLUMN --
-- ALTER TABLE public."Manufacturer" DROP COLUMN IF EXISTS name CASCADE;
ALTER TABLE public."Manufacturer" ADD COLUMN name text;
-- ddl-end --


-- object: "id_Country" | type: COLUMN --
-- ALTER TABLE public."Manufacturer" DROP COLUMN IF EXISTS "id_Country" CASCADE;
ALTER TABLE public."Manufacturer" ADD COLUMN "id_Country" integer NOT NULL;
-- ddl-end --



-- object: "Manufacturer_pk" | type: CONSTRAINT --
-- ALTER TABLE public."Manufacturer" DROP CONSTRAINT IF EXISTS "Manufacturer_pk" CASCADE;
ALTER TABLE public."Manufacturer" ADD CONSTRAINT "Manufacturer_pk" PRIMARY KEY (id);
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
);
-- ddl-end --

-- object: id | type: COLUMN --
-- ALTER TABLE public."MeasuredData" DROP COLUMN IF EXISTS id CASCADE;
ALTER TABLE public."MeasuredData" ADD COLUMN id serial NOT NULL;
-- ddl-end --


-- object: "rawValue" | type: COLUMN --
-- ALTER TABLE public."MeasuredData" DROP COLUMN IF EXISTS "rawValue" CASCADE;
ALTER TABLE public."MeasuredData" ADD COLUMN "rawValue" double precision NOT NULL;
-- ddl-end --


-- object: "convertedValue" | type: COLUMN --
-- ALTER TABLE public."MeasuredData" DROP COLUMN IF EXISTS "convertedValue" CASCADE;
ALTER TABLE public."MeasuredData" ADD COLUMN "convertedValue" double precision;
-- ddl-end --


-- object: "timestamp" | type: COLUMN --
-- ALTER TABLE public."MeasuredData" DROP COLUMN IF EXISTS "timestamp" CASCADE;
ALTER TABLE public."MeasuredData" ADD COLUMN "timestamp" timestamp with time zone;
-- ddl-end --


-- object: "code_Station_Sensor_MeasurementUnit" | type: COLUMN --
-- ALTER TABLE public."MeasuredData" DROP COLUMN IF EXISTS "code_Station_Sensor_MeasurementUnit" CASCADE;
ALTER TABLE public."MeasuredData" ADD COLUMN "code_Station_Sensor_MeasurementUnit" char(16) NOT NULL;
-- ddl-end --



-- object: "MeasuredData_pk" | type: CONSTRAINT --
-- ALTER TABLE public."MeasuredData" DROP CONSTRAINT IF EXISTS "MeasuredData_pk" CASCADE;
ALTER TABLE public."MeasuredData" ADD CONSTRAINT "MeasuredData_pk" PRIMARY KEY (id);
-- ddl-end --

ALTER TABLE public."MeasuredData" OWNER TO smartfarmer;
-- ddl-end --

-- object: public."TimeSeries" | type: TABLE --
-- DROP TABLE IF EXISTS public."TimeSeries" CASCADE;
CREATE TABLE public."TimeSeries" (
);
-- ddl-end --

-- object: id | type: COLUMN --
-- ALTER TABLE public."TimeSeries" DROP COLUMN IF EXISTS id CASCADE;
ALTER TABLE public."TimeSeries" ADD COLUMN id serial NOT NULL;
-- ddl-end --


-- object: "startTS" | type: COLUMN --
-- ALTER TABLE public."TimeSeries" DROP COLUMN IF EXISTS "startTS" CASCADE;
ALTER TABLE public."TimeSeries" ADD COLUMN "startTS" timestamp with time zone NOT NULL;
-- ddl-end --


-- object: "endTS" | type: COLUMN --
-- ALTER TABLE public."TimeSeries" DROP COLUMN IF EXISTS "endTS" CASCADE;
ALTER TABLE public."TimeSeries" ADD COLUMN "endTS" timestamp with time zone NOT NULL;
-- ddl-end --


-- object: count | type: COLUMN --
-- ALTER TABLE public."TimeSeries" DROP COLUMN IF EXISTS count CASCADE;
ALTER TABLE public."TimeSeries" ADD COLUMN count integer;
-- ddl-end --


-- object: sum | type: COLUMN --
-- ALTER TABLE public."TimeSeries" DROP COLUMN IF EXISTS sum CASCADE;
ALTER TABLE public."TimeSeries" ADD COLUMN sum double precision;
-- ddl-end --


-- object: average | type: COLUMN --
-- ALTER TABLE public."TimeSeries" DROP COLUMN IF EXISTS average CASCADE;
ALTER TABLE public."TimeSeries" ADD COLUMN average double precision;
-- ddl-end --


-- object: min | type: COLUMN --
-- ALTER TABLE public."TimeSeries" DROP COLUMN IF EXISTS min CASCADE;
ALTER TABLE public."TimeSeries" ADD COLUMN min double precision;
-- ddl-end --


-- object: max | type: COLUMN --
-- ALTER TABLE public."TimeSeries" DROP COLUMN IF EXISTS max CASCADE;
ALTER TABLE public."TimeSeries" ADD COLUMN max double precision;
-- ddl-end --


-- object: "code_Station_Sensor_MeasurementUnit" | type: COLUMN --
-- ALTER TABLE public."TimeSeries" DROP COLUMN IF EXISTS "code_Station_Sensor_MeasurementUnit" CASCADE;
ALTER TABLE public."TimeSeries" ADD COLUMN "code_Station_Sensor_MeasurementUnit" char(16) NOT NULL;
-- ddl-end --


-- object: "id_TimeSeriesInterval" | type: COLUMN --
-- ALTER TABLE public."TimeSeries" DROP COLUMN IF EXISTS "id_TimeSeriesInterval" CASCADE;
ALTER TABLE public."TimeSeries" ADD COLUMN "id_TimeSeriesInterval" integer;
-- ddl-end --



-- object: "TimeSeries_pk" | type: CONSTRAINT --
-- ALTER TABLE public."TimeSeries" DROP CONSTRAINT IF EXISTS "TimeSeries_pk" CASCADE;
ALTER TABLE public."TimeSeries" ADD CONSTRAINT "TimeSeries_pk" PRIMARY KEY (id);
-- ddl-end --

ALTER TABLE public."TimeSeries" OWNER TO smartfarmer;
-- ddl-end --

-- object: public."TimeSeriesInterval" | type: TABLE --
-- DROP TABLE IF EXISTS public."TimeSeriesInterval" CASCADE;
CREATE TABLE public."TimeSeriesInterval" (
);
-- ddl-end --

-- object: id | type: COLUMN --
-- ALTER TABLE public."TimeSeriesInterval" DROP COLUMN IF EXISTS id CASCADE;
ALTER TABLE public."TimeSeriesInterval" ADD COLUMN id serial NOT NULL;
-- ddl-end --


-- object: description | type: COLUMN --
-- ALTER TABLE public."TimeSeriesInterval" DROP COLUMN IF EXISTS description CASCADE;
ALTER TABLE public."TimeSeriesInterval" ADD COLUMN description text NOT NULL;
-- ddl-end --



-- object: "TimeSeriesInterval_pk" | type: CONSTRAINT --
-- ALTER TABLE public."TimeSeriesInterval" DROP CONSTRAINT IF EXISTS "TimeSeriesInterval_pk" CASCADE;
ALTER TABLE public."TimeSeriesInterval" ADD CONSTRAINT "TimeSeriesInterval_pk" PRIMARY KEY (id);
-- ddl-end --

ALTER TABLE public."TimeSeriesInterval" OWNER TO smartfarmer;
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
);
-- ddl-end --

-- object: id | type: COLUMN --
-- ALTER TABLE public."Country" DROP COLUMN IF EXISTS id CASCADE;
ALTER TABLE public."Country" ADD COLUMN id serial NOT NULL;
-- ddl-end --


-- object: name | type: COLUMN --
-- ALTER TABLE public."Country" DROP COLUMN IF EXISTS name CASCADE;
ALTER TABLE public."Country" ADD COLUMN name text NOT NULL;
-- ddl-end --


-- object: code | type: COLUMN --
-- ALTER TABLE public."Country" DROP COLUMN IF EXISTS code CASCADE;
ALTER TABLE public."Country" ADD COLUMN code text NOT NULL;
-- ddl-end --



-- object: country_pk | type: CONSTRAINT --
-- ALTER TABLE public."Country" DROP CONSTRAINT IF EXISTS country_pk CASCADE;
ALTER TABLE public."Country" ADD CONSTRAINT country_pk PRIMARY KEY (id);
-- ddl-end --

-- object: "Country_Code_Unique" | type: CONSTRAINT --
-- ALTER TABLE public."Country" DROP CONSTRAINT IF EXISTS "Country_Code_Unique" CASCADE;
ALTER TABLE public."Country" ADD CONSTRAINT "Country_Code_Unique" UNIQUE (code);
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
);
-- ddl-end --

-- object: id | type: COLUMN --
-- ALTER TABLE public."Station_Sensor_MeasurementUnit" DROP COLUMN IF EXISTS id CASCADE;
ALTER TABLE public."Station_Sensor_MeasurementUnit" ADD COLUMN id serial NOT NULL;
-- ddl-end --


-- object: code | type: COLUMN --
-- ALTER TABLE public."Station_Sensor_MeasurementUnit" DROP COLUMN IF EXISTS code CASCADE;
ALTER TABLE public."Station_Sensor_MeasurementUnit" ADD COLUMN code char(16) NOT NULL;
-- ddl-end --


-- object: "id_Station" | type: COLUMN --
-- ALTER TABLE public."Station_Sensor_MeasurementUnit" DROP COLUMN IF EXISTS "id_Station" CASCADE;
ALTER TABLE public."Station_Sensor_MeasurementUnit" ADD COLUMN "id_Station" integer;
-- ddl-end --


-- object: "id_Sensor" | type: COLUMN --
-- ALTER TABLE public."Station_Sensor_MeasurementUnit" DROP COLUMN IF EXISTS "id_Sensor" CASCADE;
ALTER TABLE public."Station_Sensor_MeasurementUnit" ADD COLUMN "id_Sensor" integer;
-- ddl-end --


-- object: "id_MeasurementUnit" | type: COLUMN --
-- ALTER TABLE public."Station_Sensor_MeasurementUnit" DROP COLUMN IF EXISTS "id_MeasurementUnit" CASCADE;
ALTER TABLE public."Station_Sensor_MeasurementUnit" ADD COLUMN "id_MeasurementUnit" integer;
-- ddl-end --



-- object: "MeasuredData_Pivot_pk" | type: CONSTRAINT --
-- ALTER TABLE public."Station_Sensor_MeasurementUnit" DROP CONSTRAINT IF EXISTS "MeasuredData_Pivot_pk" CASCADE;
ALTER TABLE public."Station_Sensor_MeasurementUnit" ADD CONSTRAINT "MeasuredData_Pivot_pk" PRIMARY KEY (id);
-- ddl-end --

-- object: "MeasuredData_Pivot_Code_Unique" | type: CONSTRAINT --
-- ALTER TABLE public."Station_Sensor_MeasurementUnit" DROP CONSTRAINT IF EXISTS "MeasuredData_Pivot_Code_Unique" CASCADE;
ALTER TABLE public."Station_Sensor_MeasurementUnit" ADD CONSTRAINT "MeasuredData_Pivot_Code_Unique" UNIQUE (code);
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

-- object: "Station_fk" | type: CONSTRAINT --
-- ALTER TABLE public."Station_Sensor" DROP CONSTRAINT IF EXISTS "Station_fk" CASCADE;
ALTER TABLE public."Station_Sensor" ADD CONSTRAINT "Station_fk" FOREIGN KEY ("id_Station")
REFERENCES public."Station" (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: public."Update_SSM_Pivots" | type: FUNCTION --
-- DROP FUNCTION IF EXISTS public."Update_SSM_Pivots"() CASCADE;
CREATE FUNCTION public."Update_SSM_Pivots" ()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	PARALLEL UNSAFE
	COST 1
	AS $$
	BEGIN

		INSERT INTO public."Station_Sensor" ("id_Station", "id_Sensor") VALUES (new."id_Station", new."id_Sensor")
		ON CONFLICT ON CONSTRAINT "id_Station_id_Sensor_uq"
		DO NOTHING;

		INSERT INTO public."Sensor_MeasurementUnit"("id_Sensor", "id_MeasurementUnit") VALUES (new."id_Sensor", new."id_MeasurementUnit")
		ON CONFLICT ON CONSTRAINT "id_Sensor_id_MeasurementUnit_uq" 
		DO NOTHING;

		RETURN new;
	END
$$;
-- ddl-end --
ALTER FUNCTION public."Update_SSM_Pivots"() OWNER TO smartfarmer;
-- ddl-end --

-- object: "SSM_Update_Pivot" | type: TRIGGER --
-- DROP TRIGGER IF EXISTS "SSM_Update_Pivot" ON public."Station_Sensor_MeasurementUnit" CASCADE;
CREATE TRIGGER "SSM_Update_Pivot"
	AFTER INSERT 
	ON public."Station_Sensor_MeasurementUnit"
	FOR EACH ROW
	EXECUTE PROCEDURE public."Update_SSM_Pivots"();
-- ddl-end --

-- object: public."Farm" | type: TABLE --
-- DROP TABLE IF EXISTS public."Farm" CASCADE;
CREATE TABLE public."Farm" (
);
-- ddl-end --

-- object: id | type: COLUMN --
-- ALTER TABLE public."Farm" DROP COLUMN IF EXISTS id CASCADE;
ALTER TABLE public."Farm" ADD COLUMN id serial NOT NULL;
-- ddl-end --


-- object: name | type: COLUMN --
-- ALTER TABLE public."Farm" DROP COLUMN IF EXISTS name CASCADE;
ALTER TABLE public."Farm" ADD COLUMN name text;
-- ddl-end --


-- object: description | type: COLUMN --
-- ALTER TABLE public."Farm" DROP COLUMN IF EXISTS description CASCADE;
ALTER TABLE public."Farm" ADD COLUMN description text;
-- ddl-end --


-- object: "createdAt" | type: COLUMN --
-- ALTER TABLE public."Farm" DROP COLUMN IF EXISTS "createdAt" CASCADE;
ALTER TABLE public."Farm" ADD COLUMN "createdAt" timestamp with time zone DEFAULT NOW();
-- ddl-end --


-- object: active | type: COLUMN --
-- ALTER TABLE public."Farm" DROP COLUMN IF EXISTS active CASCADE;
ALTER TABLE public."Farm" ADD COLUMN active boolean;
-- ddl-end --


-- object: "deactivatedAt" | type: COLUMN --
-- ALTER TABLE public."Farm" DROP COLUMN IF EXISTS "deactivatedAt" CASCADE;
ALTER TABLE public."Farm" ADD COLUMN "deactivatedAt" timestamp with time zone;
-- ddl-end --


-- object: "id_Address" | type: COLUMN --
-- ALTER TABLE public."Farm" DROP COLUMN IF EXISTS "id_Address" CASCADE;
ALTER TABLE public."Farm" ADD COLUMN "id_Address" integer;
-- ddl-end --



-- object: "Farm_pk" | type: CONSTRAINT --
-- ALTER TABLE public."Farm" DROP CONSTRAINT IF EXISTS "Farm_pk" CASCADE;
ALTER TABLE public."Farm" ADD CONSTRAINT "Farm_pk" PRIMARY KEY (id);
-- ddl-end --

ALTER TABLE public."Farm" OWNER TO smartfarmer;
-- ddl-end --

-- object: public."Farm_Station" | type: TABLE --
-- DROP TABLE IF EXISTS public."Farm_Station" CASCADE;
CREATE TABLE public."Farm_Station" (
);
-- ddl-end --

-- object: id | type: COLUMN --
-- ALTER TABLE public."Farm_Station" DROP COLUMN IF EXISTS id CASCADE;
ALTER TABLE public."Farm_Station" ADD COLUMN id serial NOT NULL;
-- ddl-end --


-- object: "id_Farm" | type: COLUMN --
-- ALTER TABLE public."Farm_Station" DROP COLUMN IF EXISTS "id_Farm" CASCADE;
ALTER TABLE public."Farm_Station" ADD COLUMN "id_Farm" integer;
-- ddl-end --


-- object: "id_Station" | type: COLUMN --
-- ALTER TABLE public."Farm_Station" DROP COLUMN IF EXISTS "id_Station" CASCADE;
ALTER TABLE public."Farm_Station" ADD COLUMN "id_Station" integer;
-- ddl-end --



-- object: "Farm_Station_pk" | type: CONSTRAINT --
-- ALTER TABLE public."Farm_Station" DROP CONSTRAINT IF EXISTS "Farm_Station_pk" CASCADE;
ALTER TABLE public."Farm_Station" ADD CONSTRAINT "Farm_Station_pk" PRIMARY KEY (id);
-- ddl-end --

ALTER TABLE public."Farm_Station" OWNER TO smartfarmer;
-- ddl-end --

-- object: "Farm_fk" | type: CONSTRAINT --
-- ALTER TABLE public."Farm_Station" DROP CONSTRAINT IF EXISTS "Farm_fk" CASCADE;
ALTER TABLE public."Farm_Station" ADD CONSTRAINT "Farm_fk" FOREIGN KEY ("id_Farm")
REFERENCES public."Farm" (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: "Station_fk" | type: CONSTRAINT --
-- ALTER TABLE public."Farm_Station" DROP CONSTRAINT IF EXISTS "Station_fk" CASCADE;
ALTER TABLE public."Farm_Station" ADD CONSTRAINT "Station_fk" FOREIGN KEY ("id_Station")
REFERENCES public."Station" (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: public."User" | type: TABLE --
-- DROP TABLE IF EXISTS public."User" CASCADE;
CREATE TABLE public."User" (
);
-- ddl-end --

-- object: id | type: COLUMN --
-- ALTER TABLE public."User" DROP COLUMN IF EXISTS id CASCADE;
ALTER TABLE public."User" ADD COLUMN id serial NOT NULL;
-- ddl-end --


-- object: name | type: COLUMN --
-- ALTER TABLE public."User" DROP COLUMN IF EXISTS name CASCADE;
ALTER TABLE public."User" ADD COLUMN name text NOT NULL;
-- ddl-end --


-- object: "firstName" | type: COLUMN --
-- ALTER TABLE public."User" DROP COLUMN IF EXISTS "firstName" CASCADE;
ALTER TABLE public."User" ADD COLUMN "firstName" text NOT NULL;
-- ddl-end --


-- object: "lastName" | type: COLUMN --
-- ALTER TABLE public."User" DROP COLUMN IF EXISTS "lastName" CASCADE;
ALTER TABLE public."User" ADD COLUMN "lastName" text NOT NULL;
-- ddl-end --


-- object: "nickName" | type: COLUMN --
-- ALTER TABLE public."User" DROP COLUMN IF EXISTS "nickName" CASCADE;
ALTER TABLE public."User" ADD COLUMN "nickName" text;
-- ddl-end --


-- object: "passwordHash" | type: COLUMN --
-- ALTER TABLE public."User" DROP COLUMN IF EXISTS "passwordHash" CASCADE;
ALTER TABLE public."User" ADD COLUMN "passwordHash" text NOT NULL;
-- ddl-end --


-- object: "createdAt" | type: COLUMN --
-- ALTER TABLE public."User" DROP COLUMN IF EXISTS "createdAt" CASCADE;
ALTER TABLE public."User" ADD COLUMN "createdAt" timestamp with time zone DEFAULT NOW();
-- ddl-end --


-- object: active | type: COLUMN --
-- ALTER TABLE public."User" DROP COLUMN IF EXISTS active CASCADE;
ALTER TABLE public."User" ADD COLUMN active boolean NOT NULL DEFAULT true;
-- ddl-end --


-- object: "deactivatedAt" | type: COLUMN --
-- ALTER TABLE public."User" DROP COLUMN IF EXISTS "deactivatedAt" CASCADE;
ALTER TABLE public."User" ADD COLUMN "deactivatedAt" timestamp with time zone;
-- ddl-end --


-- object: "id_Email" | type: COLUMN --
-- ALTER TABLE public."User" DROP COLUMN IF EXISTS "id_Email" CASCADE;
ALTER TABLE public."User" ADD COLUMN "id_Email" integer;
-- ddl-end --


-- object: "id_Address" | type: COLUMN --
-- ALTER TABLE public."User" DROP COLUMN IF EXISTS "id_Address" CASCADE;
ALTER TABLE public."User" ADD COLUMN "id_Address" integer;
-- ddl-end --



-- object: "User_pk" | type: CONSTRAINT --
-- ALTER TABLE public."User" DROP CONSTRAINT IF EXISTS "User_pk" CASCADE;
ALTER TABLE public."User" ADD CONSTRAINT "User_pk" PRIMARY KEY (id);
-- ddl-end --

ALTER TABLE public."User" OWNER TO smartfarmer;
-- ddl-end --

-- object: public."User_Farm" | type: TABLE --
-- DROP TABLE IF EXISTS public."User_Farm" CASCADE;
CREATE TABLE public."User_Farm" (
);
-- ddl-end --

-- object: id | type: COLUMN --
-- ALTER TABLE public."User_Farm" DROP COLUMN IF EXISTS id CASCADE;
ALTER TABLE public."User_Farm" ADD COLUMN id serial NOT NULL;
-- ddl-end --


-- object: "id_User" | type: COLUMN --
-- ALTER TABLE public."User_Farm" DROP COLUMN IF EXISTS "id_User" CASCADE;
ALTER TABLE public."User_Farm" ADD COLUMN "id_User" integer;
-- ddl-end --


-- object: "id_Farm" | type: COLUMN --
-- ALTER TABLE public."User_Farm" DROP COLUMN IF EXISTS "id_Farm" CASCADE;
ALTER TABLE public."User_Farm" ADD COLUMN "id_Farm" integer;
-- ddl-end --



-- object: "User_Farm_pk" | type: CONSTRAINT --
-- ALTER TABLE public."User_Farm" DROP CONSTRAINT IF EXISTS "User_Farm_pk" CASCADE;
ALTER TABLE public."User_Farm" ADD CONSTRAINT "User_Farm_pk" PRIMARY KEY (id);
-- ddl-end --

ALTER TABLE public."User_Farm" OWNER TO smartfarmer;
-- ddl-end --

-- object: "User_fk" | type: CONSTRAINT --
-- ALTER TABLE public."User_Farm" DROP CONSTRAINT IF EXISTS "User_fk" CASCADE;
ALTER TABLE public."User_Farm" ADD CONSTRAINT "User_fk" FOREIGN KEY ("id_User")
REFERENCES public."User" (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: "Farm_fk" | type: CONSTRAINT --
-- ALTER TABLE public."User_Farm" DROP CONSTRAINT IF EXISTS "Farm_fk" CASCADE;
ALTER TABLE public."User_Farm" ADD CONSTRAINT "Farm_fk" FOREIGN KEY ("id_Farm")
REFERENCES public."Farm" (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: public."Email" | type: TABLE --
-- DROP TABLE IF EXISTS public."Email" CASCADE;
CREATE TABLE public."Email" (
);
-- ddl-end --

-- object: id | type: COLUMN --
-- ALTER TABLE public."Email" DROP COLUMN IF EXISTS id CASCADE;
ALTER TABLE public."Email" ADD COLUMN id serial NOT NULL;
-- ddl-end --


-- object: address | type: COLUMN --
-- ALTER TABLE public."Email" DROP COLUMN IF EXISTS address CASCADE;
ALTER TABLE public."Email" ADD COLUMN address text NOT NULL;
-- ddl-end --



-- object: "Email_pk" | type: CONSTRAINT --
-- ALTER TABLE public."Email" DROP CONSTRAINT IF EXISTS "Email_pk" CASCADE;
ALTER TABLE public."Email" ADD CONSTRAINT "Email_pk" PRIMARY KEY (id);
-- ddl-end --

ALTER TABLE public."Email" OWNER TO smartfarmer;
-- ddl-end --

-- object: "Email_fk" | type: CONSTRAINT --
-- ALTER TABLE public."User" DROP CONSTRAINT IF EXISTS "Email_fk" CASCADE;
ALTER TABLE public."User" ADD CONSTRAINT "Email_fk" FOREIGN KEY ("id_Email")
REFERENCES public."Email" (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: public."Phone" | type: TABLE --
-- DROP TABLE IF EXISTS public."Phone" CASCADE;
CREATE TABLE public."Phone" (
);
-- ddl-end --

-- object: id | type: COLUMN --
-- ALTER TABLE public."Phone" DROP COLUMN IF EXISTS id CASCADE;
ALTER TABLE public."Phone" ADD COLUMN id serial NOT NULL;
-- ddl-end --


-- object: "DDD" | type: COLUMN --
-- ALTER TABLE public."Phone" DROP COLUMN IF EXISTS "DDD" CASCADE;
ALTER TABLE public."Phone" ADD COLUMN "DDD" text;
-- ddl-end --


-- object: "DDI" | type: COLUMN --
-- ALTER TABLE public."Phone" DROP COLUMN IF EXISTS "DDI" CASCADE;
ALTER TABLE public."Phone" ADD COLUMN "DDI" text;
-- ddl-end --


-- object: number | type: COLUMN --
-- ALTER TABLE public."Phone" DROP COLUMN IF EXISTS number CASCADE;
ALTER TABLE public."Phone" ADD COLUMN number text;
-- ddl-end --


-- object: active | type: COLUMN --
-- ALTER TABLE public."Phone" DROP COLUMN IF EXISTS active CASCADE;
ALTER TABLE public."Phone" ADD COLUMN active boolean NOT NULL DEFAULT true;
-- ddl-end --


-- object: "id_PhoneType" | type: COLUMN --
-- ALTER TABLE public."Phone" DROP COLUMN IF EXISTS "id_PhoneType" CASCADE;
ALTER TABLE public."Phone" ADD COLUMN "id_PhoneType" integer;
-- ddl-end --



-- object: "Phone_pk" | type: CONSTRAINT --
-- ALTER TABLE public."Phone" DROP CONSTRAINT IF EXISTS "Phone_pk" CASCADE;
ALTER TABLE public."Phone" ADD CONSTRAINT "Phone_pk" PRIMARY KEY (id);
-- ddl-end --

ALTER TABLE public."Phone" OWNER TO smartfarmer;
-- ddl-end --

-- object: public."User_Phone" | type: TABLE --
-- DROP TABLE IF EXISTS public."User_Phone" CASCADE;
CREATE TABLE public."User_Phone" (
);
-- ddl-end --

-- object: id | type: COLUMN --
-- ALTER TABLE public."User_Phone" DROP COLUMN IF EXISTS id CASCADE;
ALTER TABLE public."User_Phone" ADD COLUMN id serial NOT NULL;
-- ddl-end --


-- object: "id_User" | type: COLUMN --
-- ALTER TABLE public."User_Phone" DROP COLUMN IF EXISTS "id_User" CASCADE;
ALTER TABLE public."User_Phone" ADD COLUMN "id_User" integer;
-- ddl-end --


-- object: "id_Phone" | type: COLUMN --
-- ALTER TABLE public."User_Phone" DROP COLUMN IF EXISTS "id_Phone" CASCADE;
ALTER TABLE public."User_Phone" ADD COLUMN "id_Phone" integer;
-- ddl-end --



-- object: "User_Phone_pk" | type: CONSTRAINT --
-- ALTER TABLE public."User_Phone" DROP CONSTRAINT IF EXISTS "User_Phone_pk" CASCADE;
ALTER TABLE public."User_Phone" ADD CONSTRAINT "User_Phone_pk" PRIMARY KEY (id);
-- ddl-end --

ALTER TABLE public."User_Phone" OWNER TO smartfarmer;
-- ddl-end --

-- object: "User_fk" | type: CONSTRAINT --
-- ALTER TABLE public."User_Phone" DROP CONSTRAINT IF EXISTS "User_fk" CASCADE;
ALTER TABLE public."User_Phone" ADD CONSTRAINT "User_fk" FOREIGN KEY ("id_User")
REFERENCES public."User" (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: "Phone_fk" | type: CONSTRAINT --
-- ALTER TABLE public."User_Phone" DROP CONSTRAINT IF EXISTS "Phone_fk" CASCADE;
ALTER TABLE public."User_Phone" ADD CONSTRAINT "Phone_fk" FOREIGN KEY ("id_Phone")
REFERENCES public."Phone" (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: public."PhoneType" | type: TABLE --
-- DROP TABLE IF EXISTS public."PhoneType" CASCADE;
CREATE TABLE public."PhoneType" (
);
-- ddl-end --

-- object: id | type: COLUMN --
-- ALTER TABLE public."PhoneType" DROP COLUMN IF EXISTS id CASCADE;
ALTER TABLE public."PhoneType" ADD COLUMN id serial NOT NULL;
-- ddl-end --


-- object: description | type: COLUMN --
-- ALTER TABLE public."PhoneType" DROP COLUMN IF EXISTS description CASCADE;
ALTER TABLE public."PhoneType" ADD COLUMN description text NOT NULL;
-- ddl-end --



-- object: "PhoneType_pk" | type: CONSTRAINT --
-- ALTER TABLE public."PhoneType" DROP CONSTRAINT IF EXISTS "PhoneType_pk" CASCADE;
ALTER TABLE public."PhoneType" ADD CONSTRAINT "PhoneType_pk" PRIMARY KEY (id);
-- ddl-end --

ALTER TABLE public."PhoneType" OWNER TO smartfarmer;
-- ddl-end --

-- object: "PhoneType_fk" | type: CONSTRAINT --
-- ALTER TABLE public."Phone" DROP CONSTRAINT IF EXISTS "PhoneType_fk" CASCADE;
ALTER TABLE public."Phone" ADD CONSTRAINT "PhoneType_fk" FOREIGN KEY ("id_PhoneType")
REFERENCES public."PhoneType" (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: public."Address" | type: TABLE --
-- DROP TABLE IF EXISTS public."Address" CASCADE;
CREATE TABLE public."Address" (
);
-- ddl-end --

-- object: id | type: COLUMN --
-- ALTER TABLE public."Address" DROP COLUMN IF EXISTS id CASCADE;
ALTER TABLE public."Address" ADD COLUMN id serial NOT NULL;
-- ddl-end --


-- object: number | type: COLUMN --
-- ALTER TABLE public."Address" DROP COLUMN IF EXISTS number CASCADE;
ALTER TABLE public."Address" ADD COLUMN number text;
-- ddl-end --


-- object: complement | type: COLUMN --
-- ALTER TABLE public."Address" DROP COLUMN IF EXISTS complement CASCADE;
ALTER TABLE public."Address" ADD COLUMN complement text;
-- ddl-end --


-- object: active | type: COLUMN --
-- ALTER TABLE public."Address" DROP COLUMN IF EXISTS active CASCADE;
ALTER TABLE public."Address" ADD COLUMN active boolean NOT NULL DEFAULT true;
-- ddl-end --


-- object: "id_Area" | type: COLUMN --
-- ALTER TABLE public."Address" DROP COLUMN IF EXISTS "id_Area" CASCADE;
ALTER TABLE public."Address" ADD COLUMN "id_Area" integer;
-- ddl-end --



-- object: "Address_pk" | type: CONSTRAINT --
-- ALTER TABLE public."Address" DROP CONSTRAINT IF EXISTS "Address_pk" CASCADE;
ALTER TABLE public."Address" ADD CONSTRAINT "Address_pk" PRIMARY KEY (id);
-- ddl-end --

ALTER TABLE public."Address" OWNER TO smartfarmer;
-- ddl-end --

-- object: "Address_fk" | type: CONSTRAINT --
-- ALTER TABLE public."User" DROP CONSTRAINT IF EXISTS "Address_fk" CASCADE;
ALTER TABLE public."User" ADD CONSTRAINT "Address_fk" FOREIGN KEY ("id_Address")
REFERENCES public."Address" (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: "Address_fk" | type: CONSTRAINT --
-- ALTER TABLE public."Farm" DROP CONSTRAINT IF EXISTS "Address_fk" CASCADE;
ALTER TABLE public."Farm" ADD CONSTRAINT "Address_fk" FOREIGN KEY ("id_Address")
REFERENCES public."Address" (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: public."Area" | type: TABLE --
-- DROP TABLE IF EXISTS public."Area" CASCADE;
CREATE TABLE public."Area" (
);
-- ddl-end --

-- object: id | type: COLUMN --
-- ALTER TABLE public."Area" DROP COLUMN IF EXISTS id CASCADE;
ALTER TABLE public."Area" ADD COLUMN id serial NOT NULL;
-- ddl-end --


-- object: "id_PublicPlace" | type: COLUMN --
-- ALTER TABLE public."Area" DROP COLUMN IF EXISTS "id_PublicPlace" CASCADE;
ALTER TABLE public."Area" ADD COLUMN "id_PublicPlace" integer;
-- ddl-end --



-- object: "Area_pk" | type: CONSTRAINT --
-- ALTER TABLE public."Area" DROP CONSTRAINT IF EXISTS "Area_pk" CASCADE;
ALTER TABLE public."Area" ADD CONSTRAINT "Area_pk" PRIMARY KEY (id);
-- ddl-end --

ALTER TABLE public."Area" OWNER TO smartfarmer;
-- ddl-end --

-- object: public."PostalArea" | type: TABLE --
-- DROP TABLE IF EXISTS public."PostalArea" CASCADE;
CREATE TABLE public."PostalArea" (
);
-- ddl-end --

-- object: id | type: COLUMN --
-- ALTER TABLE public."PostalArea" DROP COLUMN IF EXISTS id CASCADE;
ALTER TABLE public."PostalArea" ADD COLUMN id serial NOT NULL;
-- ddl-end --


-- object: "id_District" | type: COLUMN --
-- ALTER TABLE public."PostalArea" DROP COLUMN IF EXISTS "id_District" CASCADE;
ALTER TABLE public."PostalArea" ADD COLUMN "id_District" integer;
-- ddl-end --


-- object: "id_Area" | type: COLUMN --
-- ALTER TABLE public."PostalArea" DROP COLUMN IF EXISTS "id_Area" CASCADE;
ALTER TABLE public."PostalArea" ADD COLUMN "id_Area" integer;
-- ddl-end --



-- object: "PostalArea_pk" | type: CONSTRAINT --
-- ALTER TABLE public."PostalArea" DROP CONSTRAINT IF EXISTS "PostalArea_pk" CASCADE;
ALTER TABLE public."PostalArea" ADD CONSTRAINT "PostalArea_pk" PRIMARY KEY (id);
-- ddl-end --

ALTER TABLE public."PostalArea" OWNER TO smartfarmer;
-- ddl-end --

-- object: public."District" | type: TABLE --
-- DROP TABLE IF EXISTS public."District" CASCADE;
CREATE TABLE public."District" (
);
-- ddl-end --

-- object: id | type: COLUMN --
-- ALTER TABLE public."District" DROP COLUMN IF EXISTS id CASCADE;
ALTER TABLE public."District" ADD COLUMN id serial NOT NULL;
-- ddl-end --


-- object: "id_City" | type: COLUMN --
-- ALTER TABLE public."District" DROP COLUMN IF EXISTS "id_City" CASCADE;
ALTER TABLE public."District" ADD COLUMN "id_City" integer;
-- ddl-end --



-- object: "District_pk" | type: CONSTRAINT --
-- ALTER TABLE public."District" DROP CONSTRAINT IF EXISTS "District_pk" CASCADE;
ALTER TABLE public."District" ADD CONSTRAINT "District_pk" PRIMARY KEY (id);
-- ddl-end --

ALTER TABLE public."District" OWNER TO smartfarmer;
-- ddl-end --

-- object: public."PublicPlace" | type: TABLE --
-- DROP TABLE IF EXISTS public."PublicPlace" CASCADE;
CREATE TABLE public."PublicPlace" (
);
-- ddl-end --

-- object: id | type: COLUMN --
-- ALTER TABLE public."PublicPlace" DROP COLUMN IF EXISTS id CASCADE;
ALTER TABLE public."PublicPlace" ADD COLUMN id serial NOT NULL;
-- ddl-end --


-- object: "id_District" | type: COLUMN --
-- ALTER TABLE public."PublicPlace" DROP COLUMN IF EXISTS "id_District" CASCADE;
ALTER TABLE public."PublicPlace" ADD COLUMN "id_District" integer;
-- ddl-end --


-- object: "id_PublicPlaceType" | type: COLUMN --
-- ALTER TABLE public."PublicPlace" DROP COLUMN IF EXISTS "id_PublicPlaceType" CASCADE;
ALTER TABLE public."PublicPlace" ADD COLUMN "id_PublicPlaceType" integer;
-- ddl-end --



-- object: "PublicPlace_pk" | type: CONSTRAINT --
-- ALTER TABLE public."PublicPlace" DROP CONSTRAINT IF EXISTS "PublicPlace_pk" CASCADE;
ALTER TABLE public."PublicPlace" ADD CONSTRAINT "PublicPlace_pk" PRIMARY KEY (id);
-- ddl-end --

ALTER TABLE public."PublicPlace" OWNER TO smartfarmer;
-- ddl-end --

-- object: public."PublicPlaceType" | type: TABLE --
-- DROP TABLE IF EXISTS public."PublicPlaceType" CASCADE;
CREATE TABLE public."PublicPlaceType" (
);
-- ddl-end --

-- object: id | type: COLUMN --
-- ALTER TABLE public."PublicPlaceType" DROP COLUMN IF EXISTS id CASCADE;
ALTER TABLE public."PublicPlaceType" ADD COLUMN id serial NOT NULL;
-- ddl-end --


-- object: name | type: COLUMN --
-- ALTER TABLE public."PublicPlaceType" DROP COLUMN IF EXISTS name CASCADE;
ALTER TABLE public."PublicPlaceType" ADD COLUMN name text NOT NULL;
-- ddl-end --



-- object: "PublicPlaceType_pk" | type: CONSTRAINT --
-- ALTER TABLE public."PublicPlaceType" DROP CONSTRAINT IF EXISTS "PublicPlaceType_pk" CASCADE;
ALTER TABLE public."PublicPlaceType" ADD CONSTRAINT "PublicPlaceType_pk" PRIMARY KEY (id);
-- ddl-end --

ALTER TABLE public."PublicPlaceType" OWNER TO smartfarmer;
-- ddl-end --

-- object: public."City" | type: TABLE --
-- DROP TABLE IF EXISTS public."City" CASCADE;
CREATE TABLE public."City" (
);
-- ddl-end --

-- object: id | type: COLUMN --
-- ALTER TABLE public."City" DROP COLUMN IF EXISTS id CASCADE;
ALTER TABLE public."City" ADD COLUMN id serial NOT NULL;
-- ddl-end --


-- object: name | type: COLUMN --
-- ALTER TABLE public."City" DROP COLUMN IF EXISTS name CASCADE;
ALTER TABLE public."City" ADD COLUMN name text;
-- ddl-end --


-- object: "id_State" | type: COLUMN --
-- ALTER TABLE public."City" DROP COLUMN IF EXISTS "id_State" CASCADE;
ALTER TABLE public."City" ADD COLUMN "id_State" integer;
-- ddl-end --



-- object: "City_pk" | type: CONSTRAINT --
-- ALTER TABLE public."City" DROP CONSTRAINT IF EXISTS "City_pk" CASCADE;
ALTER TABLE public."City" ADD CONSTRAINT "City_pk" PRIMARY KEY (id);
-- ddl-end --

ALTER TABLE public."City" OWNER TO smartfarmer;
-- ddl-end --

-- object: public."State" | type: TABLE --
-- DROP TABLE IF EXISTS public."State" CASCADE;
CREATE TABLE public."State" (
);
-- ddl-end --

-- object: id | type: COLUMN --
-- ALTER TABLE public."State" DROP COLUMN IF EXISTS id CASCADE;
ALTER TABLE public."State" ADD COLUMN id serial NOT NULL;
-- ddl-end --


-- object: name | type: COLUMN --
-- ALTER TABLE public."State" DROP COLUMN IF EXISTS name CASCADE;
ALTER TABLE public."State" ADD COLUMN name text;
-- ddl-end --


-- object: "id_Country" | type: COLUMN --
-- ALTER TABLE public."State" DROP COLUMN IF EXISTS "id_Country" CASCADE;
ALTER TABLE public."State" ADD COLUMN "id_Country" integer;
-- ddl-end --



-- object: "State_pk" | type: CONSTRAINT --
-- ALTER TABLE public."State" DROP CONSTRAINT IF EXISTS "State_pk" CASCADE;
ALTER TABLE public."State" ADD CONSTRAINT "State_pk" PRIMARY KEY (id);
-- ddl-end --

ALTER TABLE public."State" OWNER TO smartfarmer;
-- ddl-end --

-- object: "Country_fk" | type: CONSTRAINT --
-- ALTER TABLE public."State" DROP CONSTRAINT IF EXISTS "Country_fk" CASCADE;
ALTER TABLE public."State" ADD CONSTRAINT "Country_fk" FOREIGN KEY ("id_Country")
REFERENCES public."Country" (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: "State_fk" | type: CONSTRAINT --
-- ALTER TABLE public."City" DROP CONSTRAINT IF EXISTS "State_fk" CASCADE;
ALTER TABLE public."City" ADD CONSTRAINT "State_fk" FOREIGN KEY ("id_State")
REFERENCES public."State" (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: "City_fk" | type: CONSTRAINT --
-- ALTER TABLE public."District" DROP CONSTRAINT IF EXISTS "City_fk" CASCADE;
ALTER TABLE public."District" ADD CONSTRAINT "City_fk" FOREIGN KEY ("id_City")
REFERENCES public."City" (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: "District_fk" | type: CONSTRAINT --
-- ALTER TABLE public."PostalArea" DROP CONSTRAINT IF EXISTS "District_fk" CASCADE;
ALTER TABLE public."PostalArea" ADD CONSTRAINT "District_fk" FOREIGN KEY ("id_District")
REFERENCES public."District" (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: "District_fk" | type: CONSTRAINT --
-- ALTER TABLE public."PublicPlace" DROP CONSTRAINT IF EXISTS "District_fk" CASCADE;
ALTER TABLE public."PublicPlace" ADD CONSTRAINT "District_fk" FOREIGN KEY ("id_District")
REFERENCES public."District" (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: "PublicPlace_fk" | type: CONSTRAINT --
-- ALTER TABLE public."Area" DROP CONSTRAINT IF EXISTS "PublicPlace_fk" CASCADE;
ALTER TABLE public."Area" ADD CONSTRAINT "PublicPlace_fk" FOREIGN KEY ("id_PublicPlace")
REFERENCES public."PublicPlace" (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: "Area_fk" | type: CONSTRAINT --
-- ALTER TABLE public."Address" DROP CONSTRAINT IF EXISTS "Area_fk" CASCADE;
ALTER TABLE public."Address" ADD CONSTRAINT "Area_fk" FOREIGN KEY ("id_Area")
REFERENCES public."Area" (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: "Area_fk" | type: CONSTRAINT --
-- ALTER TABLE public."PostalArea" DROP CONSTRAINT IF EXISTS "Area_fk" CASCADE;
ALTER TABLE public."PostalArea" ADD CONSTRAINT "Area_fk" FOREIGN KEY ("id_Area")
REFERENCES public."Area" (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: "PublicPlaceType_fk" | type: CONSTRAINT --
-- ALTER TABLE public."PublicPlace" DROP CONSTRAINT IF EXISTS "PublicPlaceType_fk" CASCADE;
ALTER TABLE public."PublicPlace" ADD CONSTRAINT "PublicPlaceType_fk" FOREIGN KEY ("id_PublicPlaceType")
REFERENCES public."PublicPlaceType" (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: timestamp_index | type: INDEX --
-- DROP INDEX IF EXISTS public.timestamp_index CASCADE;
CREATE INDEX timestamp_index ON public."MeasuredData"
USING btree
(
	"timestamp"
);
-- ddl-end --

-- object: "id_Sensor_id_MeasurementUnit_uq" | type: CONSTRAINT --
-- ALTER TABLE public."Sensor_MeasurementUnit" DROP CONSTRAINT IF EXISTS "id_Sensor_id_MeasurementUnit_uq" CASCADE;
ALTER TABLE public."Sensor_MeasurementUnit" ADD CONSTRAINT "id_Sensor_id_MeasurementUnit_uq" UNIQUE ("id_MeasurementUnit","id_Sensor");
-- ddl-end --
COMMENT ON CONSTRAINT "id_Sensor_id_MeasurementUnit_uq" ON public."Sensor_MeasurementUnit"  IS E'The pair of Sensor ID and MeasurementUnit ID has to be unique';
-- ddl-end --


-- object: "id_Station_id_Sensor_uq" | type: CONSTRAINT --
-- ALTER TABLE public."Station_Sensor" DROP CONSTRAINT IF EXISTS "id_Station_id_Sensor_uq" CASCADE;
ALTER TABLE public."Station_Sensor" ADD CONSTRAINT "id_Station_id_Sensor_uq" UNIQUE ("id_Station","id_Sensor");
-- ddl-end --

-- object: "Station_Sensor_MeasurementUnit_fk" | type: CONSTRAINT --
-- ALTER TABLE public."MeasuredData" DROP CONSTRAINT IF EXISTS "Station_Sensor_MeasurementUnit_fk" CASCADE;
ALTER TABLE public."MeasuredData" ADD CONSTRAINT "Station_Sensor_MeasurementUnit_fk" FOREIGN KEY ("code_Station_Sensor_MeasurementUnit")
REFERENCES public."Station_Sensor_MeasurementUnit" (code) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: "code_Station_Sensor_MeasurementUnit_fk" | type: CONSTRAINT --
-- ALTER TABLE public."TimeSeries" DROP CONSTRAINT IF EXISTS "code_Station_Sensor_MeasurementUnit_fk" CASCADE;
ALTER TABLE public."TimeSeries" ADD CONSTRAINT "code_Station_Sensor_MeasurementUnit_fk" FOREIGN KEY ("code_Station_Sensor_MeasurementUnit")
REFERENCES public."Station_Sensor_MeasurementUnit" (code) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --


-- Appended SQL commands --
INSERT INTO "SensorMeasurementConversion" ("equation", "description")
VALUES
    ('20.25 * raw - 8.1', 'equação de conversão dos valores do anemômetro'),
    ('raw / (17.8846 - 0.01306 * raw)', 'equação de conversão dos valores da umidade do chão, solo davis'),
    ('raw * 598.8024', 'equação de conversão dos valores da placa solar');

-- ddl-end --