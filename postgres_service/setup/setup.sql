-- Database generated with pgModeler (PostgreSQL Database Modeler).
-- pgModeler version: 1.0.0-alpha
-- PostgreSQL version: 14.0
-- Project Site: pgmodeler.io
-- Model Author: Jedson Gabriel

SET check_function_bodies = false;
-- ddl-end --

-- object: public."Station" | type: TABLE --
-- DROP TABLE IF EXISTS public."Station" CASCADE;
CREATE TABLE IF NOT EXISTS public."Station" (
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
CREATE TABLE IF NOT EXISTS public."StationModel" (
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
CREATE TABLE IF NOT EXISTS public."Station_Sensor" (
	id serial NOT NULL,
	"id_Sensor" integer,
	"id_Station" integer,
	CONSTRAINT "StationSensor_pk" PRIMARY KEY (id)
);
-- ddl-end --
ALTER TABLE public."Station_Sensor" OWNER TO smartfarmer;
-- ddl-end --

-- object: public."Sensor" | type: TABLE --
-- DROP TABLE IF EXISTS public."Sensor" CASCADE;
CREATE TABLE IF NOT EXISTS public."Sensor" (
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

-- object: "Sensor_fk" | type: CONSTRAINT --
-- ALTER TABLE public."Station_Sensor" DROP CONSTRAINT IF EXISTS "Sensor_fk" CASCADE;
ALTER TABLE public."Station_Sensor" ADD CONSTRAINT "Sensor_fk" FOREIGN KEY ("id_Sensor")
REFERENCES public."Sensor" (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: public."MeasurementUnit" | type: TABLE --
-- DROP TABLE IF EXISTS public."MeasurementUnit" CASCADE;
CREATE TABLE IF NOT EXISTS public."MeasurementUnit" (
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

-- object: public."Sensor_MeasurementUnit" | type: TABLE --
-- DROP TABLE IF EXISTS public."Sensor_MeasurementUnit" CASCADE;
CREATE TABLE IF NOT EXISTS public."Sensor_MeasurementUnit" (
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
COMMENT ON COLUMN public."Sensor_MeasurementUnit".precision IS E'Precision of the sensor measurement for this unit';
-- ddl-end --
COMMENT ON COLUMN public."Sensor_MeasurementUnit"."minValue" IS E'Minimum value the sensor can report';
-- ddl-end --
COMMENT ON COLUMN public."Sensor_MeasurementUnit"."maxValue" IS E'Maximum value the sensor can report';
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
CREATE TABLE IF NOT EXISTS public."SensorMeasurementConversion" (
	id serial NOT NULL,
	equation text,
	description text,
	CONSTRAINT "SensorMeasurementConversion_pk" PRIMARY KEY (id)
);
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
CREATE TABLE IF NOT EXISTS public."Manufacturer" (
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
CREATE TABLE IF NOT EXISTS public."MeasuredData" (
	id serial NOT NULL,
	"rawValue" double precision NOT NULL,
	"convertedValue" double precision,
	"timestamp" timestamp with time zone,
	"code_Station_Sensor_MeasurementUnit" integer NOT NULL,
	CONSTRAINT "MeasuredData_pk" PRIMARY KEY (id)
);
-- ddl-end --
ALTER TABLE public."MeasuredData" OWNER TO smartfarmer;
-- ddl-end --

-- object: public."TimeSeries" | type: TABLE --
-- DROP TABLE IF EXISTS public."TimeSeries" CASCADE;
CREATE TABLE IF NOT EXISTS public."TimeSeries" (
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
CREATE TABLE IF NOT EXISTS public."TimeSeriesInterval" (
	id serial NOT NULL,
	description text NOT NULL,
	CONSTRAINT "TimeSeriesInterval_pk" PRIMARY KEY (id)
);
-- ddl-end --
ALTER TABLE public."TimeSeriesInterval" OWNER TO smartfarmer;
-- ddl-end --

-- object: public."TimeSeries_MeasureData" | type: TABLE --
-- DROP TABLE IF EXISTS public."TimeSeries_MeasureData" CASCADE;
CREATE TABLE IF NOT EXISTS public."TimeSeries_MeasureData" (
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
CREATE TABLE IF NOT EXISTS public."Country" (
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
CREATE TABLE IF NOT EXISTS public."Station_Sensor_MeasurementUnit" (
	id serial NOT NULL,
	code integer NOT NULL,
	"id_Station" integer,
	"id_Sensor" integer,
	"id_MeasurementUnit" integer,
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

		INSERT INTO public."Station_Sensor" ("id_Station", "id_Sensor") VALUES (new."id_Station", new."id_Sensor");

		INSERT INTO public."Sensor_MeasurementUnit"("id_Sensor", "id_MeasurementUnit") VALUES (new."id_Sensor", new."id_MeasurementUnit");

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
CREATE TABLE IF NOT EXISTS public."Farm" (
	id serial NOT NULL,
	name text,
	description text,
	"createdAt" timestamp with time zone DEFAULT NOW(),
	active boolean,
	"deactivatedAt" timestamp with time zone,
	"id_Address" integer,
	CONSTRAINT "Farm_pk" PRIMARY KEY (id)
);
-- ddl-end --
ALTER TABLE public."Farm" OWNER TO smartfarmer;
-- ddl-end --

-- object: public."Farm_Station" | type: TABLE --
-- DROP TABLE IF EXISTS public."Farm_Station" CASCADE;
CREATE TABLE IF NOT EXISTS public."Farm_Station" (
	id serial NOT NULL,
	"id_Farm" integer,
	"id_Station" integer,
	CONSTRAINT "Farm_Station_pk" PRIMARY KEY (id)
);
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
CREATE TABLE IF NOT EXISTS public."User" (
	id serial NOT NULL,
	name text NOT NULL,
	"firstName" text NOT NULL,
	"lastName" text NOT NULL,
	"nickName" text,
	"passwordHash" text NOT NULL,
	"createdAt" timestamp with time zone DEFAULT NOW(),
	active boolean NOT NULL DEFAULT true,
	"deactivatedAt" timestamp with time zone,
	"id_Email" integer,
	"id_Address" integer,
	CONSTRAINT "User_pk" PRIMARY KEY (id)
);
-- ddl-end --
ALTER TABLE public."User" OWNER TO smartfarmer;
-- ddl-end --

-- object: public."User_Farm" | type: TABLE --
-- DROP TABLE IF EXISTS public."User_Farm" CASCADE;
CREATE TABLE IF NOT EXISTS public."User_Farm" (
	id serial NOT NULL,
	"id_User" integer,
	"id_Farm" integer,
	CONSTRAINT "User_Farm_pk" PRIMARY KEY (id)
);
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
CREATE TABLE IF NOT EXISTS public."Email" (
	id serial NOT NULL,
	address text NOT NULL,
	CONSTRAINT "Email_pk" PRIMARY KEY (id)
);
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
CREATE TABLE IF NOT EXISTS public."Phone" (
	id serial NOT NULL,
	"DDD" text,
	"DDI" text,
	number text,
	active boolean NOT NULL DEFAULT true,
	"id_PhoneType" integer,
	CONSTRAINT "Phone_pk" PRIMARY KEY (id)
);
-- ddl-end --
ALTER TABLE public."Phone" OWNER TO smartfarmer;
-- ddl-end --

-- object: public."User_Phone" | type: TABLE --
-- DROP TABLE IF EXISTS public."User_Phone" CASCADE;
CREATE TABLE IF NOT EXISTS public."User_Phone" (
	id serial NOT NULL,
	"id_User" integer,
	"id_Phone" integer,
	CONSTRAINT "User_Phone_pk" PRIMARY KEY (id)
);
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
CREATE TABLE IF NOT EXISTS public."PhoneType" (
	id serial NOT NULL,
	description text NOT NULL,
	CONSTRAINT "PhoneType_pk" PRIMARY KEY (id)
);
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
CREATE TABLE IF NOT EXISTS public."Address" (
	id serial NOT NULL,
	number text,
	complement text,
	active boolean NOT NULL DEFAULT true,
	"id_Area" integer,
	CONSTRAINT "Address_pk" PRIMARY KEY (id)
);
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
CREATE TABLE IF NOT EXISTS public."Area" (
	id serial NOT NULL,
	"id_PublicPlace" integer,
	CONSTRAINT "Area_pk" PRIMARY KEY (id)
);
-- ddl-end --
ALTER TABLE public."Area" OWNER TO smartfarmer;
-- ddl-end --

-- object: public."PostalArea" | type: TABLE --
-- DROP TABLE IF EXISTS public."PostalArea" CASCADE;
CREATE TABLE IF NOT EXISTS public."PostalArea" (
	id serial NOT NULL,
	"id_District" integer,
	"id_Area" integer,
	CONSTRAINT "PostalArea_pk" PRIMARY KEY (id)
);
-- ddl-end --
ALTER TABLE public."PostalArea" OWNER TO smartfarmer;
-- ddl-end --

-- object: public."District" | type: TABLE --
-- DROP TABLE IF EXISTS public."District" CASCADE;
CREATE TABLE IF NOT EXISTS public."District" (
	id serial NOT NULL,
	"id_City" integer,
	CONSTRAINT "District_pk" PRIMARY KEY (id)
);
-- ddl-end --
ALTER TABLE public."District" OWNER TO smartfarmer;
-- ddl-end --

-- object: public."PublicPlace" | type: TABLE --
-- DROP TABLE IF EXISTS public."PublicPlace" CASCADE;
CREATE TABLE IF NOT EXISTS public."PublicPlace" (
	id serial NOT NULL,
	"id_District" integer,
	"id_PublicPlaceType" integer,
	CONSTRAINT "PublicPlace_pk" PRIMARY KEY (id)
);
-- ddl-end --
ALTER TABLE public."PublicPlace" OWNER TO smartfarmer;
-- ddl-end --

-- object: public."PublicPlaceType" | type: TABLE --
-- DROP TABLE IF EXISTS public."PublicPlaceType" CASCADE;
CREATE TABLE IF NOT EXISTS public."PublicPlaceType" (
	id serial NOT NULL,
	name text NOT NULL,
	CONSTRAINT "PublicPlaceType_pk" PRIMARY KEY (id)
);
-- ddl-end --
ALTER TABLE public."PublicPlaceType" OWNER TO smartfarmer;
-- ddl-end --

-- object: public."City" | type: TABLE --
-- DROP TABLE IF EXISTS public."City" CASCADE;
CREATE TABLE IF NOT EXISTS public."City" (
	id serial NOT NULL,
	name text,
	"id_State" integer,
	CONSTRAINT "City_pk" PRIMARY KEY (id)
);
-- ddl-end --
ALTER TABLE public."City" OWNER TO smartfarmer;
-- ddl-end --

-- object: public."State" | type: TABLE --
-- DROP TABLE IF EXISTS public."State" CASCADE;
CREATE TABLE IF NOT EXISTS public."State" (
	id serial NOT NULL,
	name text,
	"id_Country" integer,
	CONSTRAINT "State_pk" PRIMARY KEY (id)
);
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

-- object: "Station_Sensor_MeasurementUnit_fk" | type: CONSTRAINT --
-- ALTER TABLE public."MeasuredData" DROP CONSTRAINT IF EXISTS "Station_Sensor_MeasurementUnit_fk" CASCADE;
ALTER TABLE public."MeasuredData" ADD CONSTRAINT "Station_Sensor_MeasurementUnit_fk" FOREIGN KEY ("code_Station_Sensor_MeasurementUnit")
REFERENCES public."Station_Sensor_MeasurementUnit" (code) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --


