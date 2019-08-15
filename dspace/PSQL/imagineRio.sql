--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner:
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner:
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner:
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner:
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: getnextid(character varying); Type: FUNCTION; Schema: public; Owner: dspace
--

CREATE FUNCTION public.getnextid(character varying) RETURNS integer
    LANGUAGE sql
    AS $_$SELECT CAST (nextval($1 || '_seq') AS INTEGER) AS RESULT;$_$;


ALTER FUNCTION public.getnextid(character varying) OWNER TO dspace;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: bitstream; Type: TABLE; Schema: public; Owner: dspace; Tablespace:
--

CREATE TABLE public.bitstream (
    bitstream_id integer,
    bitstream_format_id integer,
    checksum character varying(64),
    checksum_algorithm character varying(32),
    internal_id character varying(256),
    deleted boolean,
    store_number integer,
    sequence_id integer,
    size_bytes bigint,
    uuid uuid DEFAULT public.gen_random_uuid() NOT NULL
);


ALTER TABLE public.bitstream OWNER TO dspace;

--
-- Name: bitstreamformatregistry; Type: TABLE; Schema: public; Owner: dspace; Tablespace:
--

CREATE TABLE public.bitstreamformatregistry (
    bitstream_format_id integer NOT NULL,
    mimetype character varying(256),
    short_description character varying(128),
    description text,
    support_level integer,
    internal boolean
);


ALTER TABLE public.bitstreamformatregistry OWNER TO dspace;

--
-- Name: bitstreamformatregistry_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.bitstreamformatregistry_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.bitstreamformatregistry_seq OWNER TO dspace;

--
-- Name: bundle; Type: TABLE; Schema: public; Owner: dspace; Tablespace:
--

CREATE TABLE public.bundle (
    bundle_id integer,
    uuid uuid DEFAULT public.gen_random_uuid() NOT NULL,
    primary_bitstream_id uuid
);


ALTER TABLE public.bundle OWNER TO dspace;

--
-- Name: bundle2bitstream; Type: TABLE; Schema: public; Owner: dspace; Tablespace:
--

CREATE TABLE public.bundle2bitstream (
    bitstream_order_legacy integer,
    bundle_id uuid NOT NULL,
    bitstream_id uuid NOT NULL,
    bitstream_order integer NOT NULL
);


ALTER TABLE public.bundle2bitstream OWNER TO dspace;

--
-- Name: checksum_history; Type: TABLE; Schema: public; Owner: dspace; Tablespace:
--

CREATE TABLE public.checksum_history (
    check_id bigint NOT NULL,
    process_start_date timestamp without time zone,
    process_end_date timestamp without time zone,
    checksum_expected character varying,
    checksum_calculated character varying,
    result character varying,
    bitstream_id uuid
);


ALTER TABLE public.checksum_history OWNER TO dspace;

--
-- Name: checksum_history_check_id_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.checksum_history_check_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.checksum_history_check_id_seq OWNER TO dspace;

--
-- Name: checksum_history_check_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dspace
--

ALTER SEQUENCE public.checksum_history_check_id_seq OWNED BY public.checksum_history.check_id;


--
-- Name: checksum_results; Type: TABLE; Schema: public; Owner: dspace; Tablespace:
--

CREATE TABLE public.checksum_results (
    result_code character varying NOT NULL,
    result_description character varying
);


ALTER TABLE public.checksum_results OWNER TO dspace;

--
-- Name: collection; Type: TABLE; Schema: public; Owner: dspace; Tablespace:
--

CREATE TABLE public.collection (
    collection_id integer,
    uuid uuid DEFAULT public.gen_random_uuid() NOT NULL,
    workflow_step_1 uuid,
    workflow_step_2 uuid,
    workflow_step_3 uuid,
    submitter uuid,
    template_item_id uuid,
    logo_bitstream_id uuid,
    admin uuid
);


ALTER TABLE public.collection OWNER TO dspace;

--
-- Name: collection2item; Type: TABLE; Schema: public; Owner: dspace; Tablespace:
--

CREATE TABLE public.collection2item (
    collection_id uuid NOT NULL,
    item_id uuid NOT NULL
);


ALTER TABLE public.collection2item OWNER TO dspace;

--
-- Name: community; Type: TABLE; Schema: public; Owner: dspace; Tablespace:
--

CREATE TABLE public.community (
    community_id integer,
    uuid uuid DEFAULT public.gen_random_uuid() NOT NULL,
    admin uuid,
    logo_bitstream_id uuid
);


ALTER TABLE public.community OWNER TO dspace;

--
-- Name: community2collection; Type: TABLE; Schema: public; Owner: dspace; Tablespace:
--

CREATE TABLE public.community2collection (
    collection_id uuid NOT NULL,
    community_id uuid NOT NULL
);


ALTER TABLE public.community2collection OWNER TO dspace;

--
-- Name: community2community; Type: TABLE; Schema: public; Owner: dspace; Tablespace:
--

CREATE TABLE public.community2community (
    parent_comm_id uuid NOT NULL,
    child_comm_id uuid NOT NULL
);


ALTER TABLE public.community2community OWNER TO dspace;

--
-- Name: doi; Type: TABLE; Schema: public; Owner: dspace; Tablespace:
--

CREATE TABLE public.doi (
    doi_id integer NOT NULL,
    doi character varying(256),
    resource_type_id integer,
    resource_id integer,
    status integer,
    dspace_object uuid
);


ALTER TABLE public.doi OWNER TO dspace;

--
-- Name: doi_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.doi_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.doi_seq OWNER TO dspace;

--
-- Name: dspaceobject; Type: TABLE; Schema: public; Owner: dspace; Tablespace:
--

CREATE TABLE public.dspaceobject (
    uuid uuid NOT NULL
);


ALTER TABLE public.dspaceobject OWNER TO dspace;

--
-- Name: eperson; Type: TABLE; Schema: public; Owner: dspace; Tablespace:
--

CREATE TABLE public.eperson (
    eperson_id integer,
    email character varying(64),
    password character varying(128),
    can_log_in boolean,
    require_certificate boolean,
    self_registered boolean,
    last_active timestamp without time zone,
    sub_frequency integer,
    netid character varying(64),
    salt character varying(32),
    digest_algorithm character varying(16),
    uuid uuid DEFAULT public.gen_random_uuid() NOT NULL
);


ALTER TABLE public.eperson OWNER TO dspace;

--
-- Name: epersongroup; Type: TABLE; Schema: public; Owner: dspace; Tablespace:
--

CREATE TABLE public.epersongroup (
    eperson_group_id integer,
    uuid uuid DEFAULT public.gen_random_uuid() NOT NULL,
    permanent boolean DEFAULT false,
    name character varying(250)
);


ALTER TABLE public.epersongroup OWNER TO dspace;

--
-- Name: epersongroup2eperson; Type: TABLE; Schema: public; Owner: dspace; Tablespace:
--

CREATE TABLE public.epersongroup2eperson (
    eperson_group_id uuid NOT NULL,
    eperson_id uuid NOT NULL
);


ALTER TABLE public.epersongroup2eperson OWNER TO dspace;

--
-- Name: epersongroup2workspaceitem; Type: TABLE; Schema: public; Owner: dspace; Tablespace:
--

CREATE TABLE public.epersongroup2workspaceitem (
    workspace_item_id integer NOT NULL,
    eperson_group_id uuid NOT NULL
);


ALTER TABLE public.epersongroup2workspaceitem OWNER TO dspace;

--
-- Name: fileextension; Type: TABLE; Schema: public; Owner: dspace; Tablespace:
--

CREATE TABLE public.fileextension (
    file_extension_id integer NOT NULL,
    bitstream_format_id integer,
    extension character varying(16)
);


ALTER TABLE public.fileextension OWNER TO dspace;

--
-- Name: fileextension_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.fileextension_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.fileextension_seq OWNER TO dspace;

--
-- Name: group2group; Type: TABLE; Schema: public; Owner: dspace; Tablespace:
--

CREATE TABLE public.group2group (
    parent_id uuid NOT NULL,
    child_id uuid NOT NULL
);


ALTER TABLE public.group2group OWNER TO dspace;

--
-- Name: group2groupcache; Type: TABLE; Schema: public; Owner: dspace; Tablespace:
--

CREATE TABLE public.group2groupcache (
    parent_id uuid NOT NULL,
    child_id uuid NOT NULL
);


ALTER TABLE public.group2groupcache OWNER TO dspace;

--
-- Name: handle; Type: TABLE; Schema: public; Owner: dspace; Tablespace:
--

CREATE TABLE public.handle (
    handle_id integer NOT NULL,
    handle character varying(256),
    resource_type_id integer,
    resource_legacy_id integer,
    resource_id uuid
);


ALTER TABLE public.handle OWNER TO dspace;

--
-- Name: handle_id_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.handle_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.handle_id_seq OWNER TO dspace;

--
-- Name: handle_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.handle_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.handle_seq OWNER TO dspace;

--
-- Name: harvested_collection; Type: TABLE; Schema: public; Owner: dspace; Tablespace:
--

CREATE TABLE public.harvested_collection (
    harvest_type integer,
    oai_source character varying,
    oai_set_id character varying,
    harvest_message character varying,
    metadata_config_id character varying,
    harvest_status integer,
    harvest_start_time timestamp with time zone,
    last_harvested timestamp with time zone,
    id integer NOT NULL,
    collection_id uuid
);


ALTER TABLE public.harvested_collection OWNER TO dspace;

--
-- Name: harvested_collection_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.harvested_collection_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.harvested_collection_seq OWNER TO dspace;

--
-- Name: harvested_item; Type: TABLE; Schema: public; Owner: dspace; Tablespace:
--

CREATE TABLE public.harvested_item (
    last_harvested timestamp with time zone,
    oai_id character varying,
    id integer NOT NULL,
    item_id uuid
);


ALTER TABLE public.harvested_item OWNER TO dspace;

--
-- Name: harvested_item_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.harvested_item_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.harvested_item_seq OWNER TO dspace;

--
-- Name: history_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.history_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.history_seq OWNER TO dspace;

--
-- Name: item; Type: TABLE; Schema: public; Owner: dspace; Tablespace:
--

CREATE TABLE public.item (
    item_id integer,
    in_archive boolean,
    withdrawn boolean,
    last_modified timestamp with time zone,
    discoverable boolean,
    uuid uuid DEFAULT public.gen_random_uuid() NOT NULL,
    submitter_id uuid,
    owning_collection uuid
);


ALTER TABLE public.item OWNER TO dspace;

--
-- Name: item2bundle; Type: TABLE; Schema: public; Owner: dspace; Tablespace:
--

CREATE TABLE public.item2bundle (
    bundle_id uuid NOT NULL,
    item_id uuid NOT NULL
);


ALTER TABLE public.item2bundle OWNER TO dspace;

--
-- Name: metadatafieldregistry_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.metadatafieldregistry_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.metadatafieldregistry_seq OWNER TO dspace;

--
-- Name: metadatafieldregistry; Type: TABLE; Schema: public; Owner: dspace; Tablespace:
--

CREATE TABLE public.metadatafieldregistry (
    metadata_field_id integer DEFAULT nextval('public.metadatafieldregistry_seq'::regclass) NOT NULL,
    metadata_schema_id integer NOT NULL,
    element character varying(64),
    qualifier character varying(64),
    scope_note text
);


ALTER TABLE public.metadatafieldregistry OWNER TO dspace;

--
-- Name: metadataschemaregistry_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.metadataschemaregistry_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.metadataschemaregistry_seq OWNER TO dspace;

--
-- Name: metadataschemaregistry; Type: TABLE; Schema: public; Owner: dspace; Tablespace:
--

CREATE TABLE public.metadataschemaregistry (
    metadata_schema_id integer DEFAULT nextval('public.metadataschemaregistry_seq'::regclass) NOT NULL,
    namespace character varying(256),
    short_id character varying(32)
);


ALTER TABLE public.metadataschemaregistry OWNER TO dspace;

--
-- Name: metadatavalue_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.metadatavalue_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.metadatavalue_seq OWNER TO dspace;

--
-- Name: metadatavalue; Type: TABLE; Schema: public; Owner: dspace; Tablespace:
--

CREATE TABLE public.metadatavalue (
    metadata_value_id integer DEFAULT nextval('public.metadatavalue_seq'::regclass) NOT NULL,
    metadata_field_id integer,
    text_value text,
    text_lang character varying(24),
    place integer,
    authority character varying(100),
    confidence integer DEFAULT (-1),
    dspace_object_id uuid
);


ALTER TABLE public.metadatavalue OWNER TO dspace;

--
-- Name: most_recent_checksum; Type: TABLE; Schema: public; Owner: dspace; Tablespace:
--

CREATE TABLE public.most_recent_checksum (
    to_be_processed boolean NOT NULL,
    expected_checksum character varying NOT NULL,
    current_checksum character varying NOT NULL,
    last_process_start_date timestamp without time zone NOT NULL,
    last_process_end_date timestamp without time zone NOT NULL,
    checksum_algorithm character varying NOT NULL,
    matched_prev_checksum boolean NOT NULL,
    result character varying,
    bitstream_id uuid
);


ALTER TABLE public.most_recent_checksum OWNER TO dspace;

--
-- Name: registrationdata; Type: TABLE; Schema: public; Owner: dspace; Tablespace:
--

CREATE TABLE public.registrationdata (
    registrationdata_id integer NOT NULL,
    email character varying(64),
    token character varying(48),
    expires timestamp without time zone
);


ALTER TABLE public.registrationdata OWNER TO dspace;

--
-- Name: registrationdata_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.registrationdata_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.registrationdata_seq OWNER TO dspace;

--
-- Name: requestitem; Type: TABLE; Schema: public; Owner: dspace; Tablespace:
--

CREATE TABLE public.requestitem (
    requestitem_id integer NOT NULL,
    token character varying(48),
    allfiles boolean,
    request_email character varying(64),
    request_name character varying(64),
    request_date timestamp without time zone,
    accept_request boolean,
    decision_date timestamp without time zone,
    expires timestamp without time zone,
    request_message text,
    item_id uuid,
    bitstream_id uuid
);


ALTER TABLE public.requestitem OWNER TO dspace;

--
-- Name: requestitem_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.requestitem_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.requestitem_seq OWNER TO dspace;

--
-- Name: resourcepolicy; Type: TABLE; Schema: public; Owner: dspace; Tablespace:
--

CREATE TABLE public.resourcepolicy (
    policy_id integer NOT NULL,
    resource_type_id integer,
    resource_id integer,
    action_id integer,
    start_date date,
    end_date date,
    rpname character varying(30),
    rptype character varying(30),
    rpdescription text,
    eperson_id uuid,
    epersongroup_id uuid,
    dspace_object uuid
);


ALTER TABLE public.resourcepolicy OWNER TO dspace;

--
-- Name: resourcepolicy_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.resourcepolicy_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.resourcepolicy_seq OWNER TO dspace;

--
-- Name: schema_version; Type: TABLE; Schema: public; Owner: dspace; Tablespace:
--

CREATE TABLE public.schema_version (
    installed_rank integer NOT NULL,
    version character varying(50),
    description character varying(200) NOT NULL,
    type character varying(20) NOT NULL,
    script character varying(1000) NOT NULL,
    checksum integer,
    installed_by character varying(100) NOT NULL,
    installed_on timestamp without time zone DEFAULT now() NOT NULL,
    execution_time integer NOT NULL,
    success boolean NOT NULL
);


ALTER TABLE public.schema_version OWNER TO dspace;

--
-- Name: site; Type: TABLE; Schema: public; Owner: dspace; Tablespace:
--

CREATE TABLE public.site (
    uuid uuid NOT NULL
);


ALTER TABLE public.site OWNER TO dspace;

--
-- Name: subscription; Type: TABLE; Schema: public; Owner: dspace; Tablespace:
--

CREATE TABLE public.subscription (
    subscription_id integer NOT NULL,
    eperson_id uuid,
    collection_id uuid
);


ALTER TABLE public.subscription OWNER TO dspace;

--
-- Name: subscription_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.subscription_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.subscription_seq OWNER TO dspace;

--
-- Name: tasklistitem; Type: TABLE; Schema: public; Owner: dspace; Tablespace:
--

CREATE TABLE public.tasklistitem (
    tasklist_id integer NOT NULL,
    workflow_id integer,
    eperson_id uuid
);


ALTER TABLE public.tasklistitem OWNER TO dspace;

--
-- Name: tasklistitem_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.tasklistitem_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tasklistitem_seq OWNER TO dspace;

--
-- Name: versionhistory; Type: TABLE; Schema: public; Owner: dspace; Tablespace:
--

CREATE TABLE public.versionhistory (
    versionhistory_id integer NOT NULL
);


ALTER TABLE public.versionhistory OWNER TO dspace;

--
-- Name: versionhistory_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.versionhistory_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.versionhistory_seq OWNER TO dspace;

--
-- Name: versionitem; Type: TABLE; Schema: public; Owner: dspace; Tablespace:
--

CREATE TABLE public.versionitem (
    versionitem_id integer NOT NULL,
    version_number integer,
    version_date timestamp without time zone,
    version_summary character varying(255),
    versionhistory_id integer,
    eperson_id uuid,
    item_id uuid
);


ALTER TABLE public.versionitem OWNER TO dspace;

--
-- Name: versionitem_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.versionitem_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.versionitem_seq OWNER TO dspace;

--
-- Name: webapp; Type: TABLE; Schema: public; Owner: dspace; Tablespace:
--

CREATE TABLE public.webapp (
    webapp_id integer NOT NULL,
    appname character varying(32),
    url character varying,
    started timestamp without time zone,
    isui integer
);


ALTER TABLE public.webapp OWNER TO dspace;

--
-- Name: webapp_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.webapp_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.webapp_seq OWNER TO dspace;

--
-- Name: workflowitem; Type: TABLE; Schema: public; Owner: dspace; Tablespace:
--

CREATE TABLE public.workflowitem (
    workflow_id integer NOT NULL,
    state integer,
    multiple_titles boolean,
    published_before boolean,
    multiple_files boolean,
    item_id uuid,
    collection_id uuid,
    owner uuid
);


ALTER TABLE public.workflowitem OWNER TO dspace;

--
-- Name: workflowitem_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.workflowitem_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.workflowitem_seq OWNER TO dspace;

--
-- Name: workspaceitem; Type: TABLE; Schema: public; Owner: dspace; Tablespace:
--

CREATE TABLE public.workspaceitem (
    workspace_item_id integer NOT NULL,
    multiple_titles boolean,
    published_before boolean,
    multiple_files boolean,
    stage_reached integer,
    page_reached integer,
    item_id uuid,
    collection_id uuid
);


ALTER TABLE public.workspaceitem OWNER TO dspace;

--
-- Name: workspaceitem_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.workspaceitem_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.workspaceitem_seq OWNER TO dspace;

--
-- Name: check_id; Type: DEFAULT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.checksum_history ALTER COLUMN check_id SET DEFAULT nextval('public.checksum_history_check_id_seq'::regclass);


--
-- Data for Name: bitstream; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.bitstream (bitstream_id, bitstream_format_id, checksum, checksum_algorithm, internal_id, deleted, store_number, sequence_id, size_bytes, uuid) FROM stdin;
\N	16	6ae6f813b47841dbf63185f7e96f370f	MD5	33005661973256697898341890228472799977	f	0	3	3009	17d71f15-eaf1-41da-85c3-a1ac3129ea60
\N	16	06891ce4df41348255bd385adcf85647	MD5	140719252885484548334986419596559413300	f	0	1	3577813	0e574c1b-c9b0-42bc-8ab0-117200a8116a
\N	16	b5274037e55e6586bfe0689d41dfc387	MD5	168333785111888406604405638489869049861	t	0	2	70543	abb176ea-5c14-4080-a188-ecadb81b0b76
\N	16	389e0edd4df7a72475d0fb8df974e494	MD5	25145542463046169004809200979792918277	f	0	1	4925771	5dc559b8-06ba-45a3-9924-f4edd9d834bf
\N	16	bcc1918037d218d13747c1c2e4ed0b61	MD5	3168984718991029548028647882674049929	f	0	3	5562	d145f27a-a203-4663-915f-7d5718fbc387
\N	16	ff9c50d233e593e87812ccfc39125bac	MD5	41986958551470546983890669474939674824	t	0	2	133728	adfc389d-5537-472c-9a51-4f1bd18b4888
\N	16	ffd8592a32c894c082ca7438ee59df83	MD5	30140784077927998827979731811311465722	f	0	1	2383066	0c7568f7-0a7a-47cb-890b-45e76342b112
\N	16	d6814481785496f8578010a6cc9d0993	MD5	121032311749433411977631165417131464563	f	0	3	4160	46b7d0d6-e7be-499d-ae60-ec10bc7301f2
\N	16	4fc0a68f990a115c2ce8f331385a474e	MD5	68037773298178674637928415223611350094	t	0	2	134632	cd7ec348-a758-43d9-9cfa-dc1bd4f43036
\N	16	1563eb80d860861affcc6b726b7f393e	MD5	31062882542310179013656045000953752524	t	0	2	212383	f4792a10-994e-470f-a2f6-c24017cc93cb
\N	16	6913773463e6ae555de36a6bc4a053b0	MD5	143787059813970268531597740273768100703	f	0	1	19802531	2211fbd7-3a2d-429d-bae7-ecab96049a46
\N	16	091033dfab77d8b71abe88f8fe9c0c16	MD5	60078629676290231344283667292146299723	f	0	3	4676	608da05e-be8e-4edd-ba48-b952efd151cf
\N	16	deb00a29736cb8046dab125feb8925c6	MD5	93792352022688086365602839553573946943	f	0	1	2129731	cbced2d8-7ca1-40e2-9c14-b9673c4e78ef
\N	16	965c40a52589638142eaabff6ab15a75	MD5	56402286739748571341173614135988967418	t	0	2	106140	19c8f7f2-27e1-4c00-b1ed-7335499e13d9
\N	16	ff708c85b9491952be78b712e1c46776	MD5	88825936380885285917015704596975994088	t	0	2	131732	80d5242e-9daa-4a21-be6e-e461263c49b4
\N	16	eb0be42f43e9fb768e04959857826c90	MD5	11438383019464332653063608752720996208	t	0	2	156163	3ff42a9b-4597-44ae-91aa-a5c6b087e14c
\N	16	df07b723e7122ce21a3a0d14d03de600	MD5	84336179264827744036628055567652309647	f	0	1	22153446	a94555aa-4aab-4229-a822-94f5f8c35f2c
\N	16	0331b26dcfc3911baa0cc5d409865757	MD5	75595354807403858670731402948868392764	f	0	3	8087	ed372ab2-cb41-49a5-95ed-3558cdd00a13
\N	16	2d1bd84000abff9bb1ab4d471dcfb4bb	MD5	119451711103268895424649973196737276324	f	0	1	19259494	dc0680b6-5534-4091-9619-f945e80a308b
\N	16	c88131be00187e76b832d9797cfbcc05	MD5	86597789423097834439067295458048202170	f	0	3	5771	9f0fcbd3-5455-484e-9582-d996bbd00a4f
\N	16	40214234779a96a78f66ee4d33e170de	MD5	96208176790411669461239350667599274964	f	0	3	4427	a0450d8b-5720-4aca-9838-d94a779e68d6
\N	16	5ca4fb6ba5364e7f6208fa6a9544228f	MD5	1389940569386780651513918514030300781	f	0	3	3989	089f0a09-8f7b-4504-a99a-a13113cb70d7
\N	16	12178719b08b72c4ff507250ccdc775e	MD5	50359034799838881696101336925096268912	t	0	2	168981	7d3525be-a86f-455c-810a-10f048c124d0
\N	16	8a853a2d8afdd8c3a8fc3e864694dc7d	MD5	164155809220106056103907750032585014752	f	0	1	3783208	0107af4a-0e80-4d48-bceb-57e088cd92b0
\N	16	99a9e1ec38de13f2a65c5ed316126811	MD5	56341984220564632536923377506320060196	t	0	2	148319	19d68051-321e-4f01-9fc8-bbd38ffbbf82
\N	16	1b77186c4a59e6443efff68076cd63f1	MD5	22481587361391670981402242815552790124	t	0	2	97661	b1d0277b-fd8e-4fa3-8fa9-b19ed0a53d56
\N	16	636f9e3eb33df6125eda77ff9928f223	MD5	32646730502115114522533679759787700668	t	0	2	121282	37c0a70b-6d40-48fe-a528-765a5f6d86ca
\N	16	13923ae9b47cfc3083e1ae66a9f29fc9	MD5	19470799395270229090987050055121330815	t	0	2	172148	95fb37f3-03ae-4005-8266-0e2bad4d3981
\N	16	79d167962f45f563cf47b63bf9d3d44b	MD5	24650001158424598730819598286489752275	f	0	1	4471840	df126add-167e-4004-a3e0-b8b0374f885d
\N	16	332940645195b94beaca3395a705dc3c	MD5	74596147672734234057407674471959743736	t	0	2	135952	ee62897c-32d2-4b1b-944c-21b83c509d68
\N	16	645f93c7dd00bb879bc69e0d15cae1ed	MD5	121058795908030103426628555349591750755	f	0	3	7054	14704a8d-e5a9-4374-9ca5-41a0621d600c
\N	16	edab988457c58e8524da2533ae24d0ff	MD5	166423569931572545256085176412208985559	t	0	2	112510	cefd365e-cc38-49bf-bc47-01718da026b7
\N	16	42c43012749a55aedfd7b9dabe61fce7	MD5	139390796677780866655842397632618582492	f	0	1	3746620	c168ef8c-6706-4530-8e60-0162cd97980c
\N	16	e36b79399853ed236b4379f8ccfcdda5	MD5	132558953507614095673150087280548125342	f	0	3	4219	16e077ef-74a7-4622-8343-bbd7f22e91d6
\N	16	579eb1d2ac5224d7b73d9320c41736ff	MD5	7189077373515640731975616000997026255	f	0	1	5113378	d0aa8a78-9ce7-4527-8208-35d7b34fea8d
\N	16	f01bb4fc960c24c3b424713fd48dd6cd	MD5	71333832594131773136190834109596082044	f	0	3	5270	d91ce649-f50c-4122-8ad8-0c713d5ac137
\N	16	ce2e6d1c35fcf9aefdb90d3f76f5d55f	MD5	8236119721752540161320844660492497884	f	0	1	8518331	001787ca-4021-4448-b6ed-6ff1d56076c0
\N	16	a926262b9227bda49c7ac0ffdf153ff8	MD5	56856244437942282132859876344437529235	f	0	3	5947	613ee361-f8fb-4ff5-9c55-38f0cb83be45
\N	16	76f151c55595a4549e6313c9aae69ca7	MD5	52177389562891958694046398529112810427	f	0	1	17394957	7acced69-4137-4ae6-82aa-d425b7b12cbf
\N	16	ef2beb16d743dc42e096ee593f87a3c9	MD5	130279420977573816325785752140908984557	f	0	3	6295	e7bd4f9d-c802-498d-9aea-c3240c40233b
\N	16	b6c1bae93f97d633103735e7637503dc	MD5	139757158435253512415695301369066009622	f	0	1	3615715	512c54c6-fb9f-4351-a5b8-a15968510dd1
\N	16	3630fe57965c86933633c403803dae6b	MD5	140701630011340369457234240898906088119	f	0	3	3166	d4cc7466-9447-45fe-8089-d8b8f73341a3
\N	16	4dc01f2f65636b1480ceb88b42affdd6	MD5	60876456460308056195113672224134876575	f	0	1	2660821	ef5c27a6-f687-441a-8947-cb07696025e3
\N	16	0071f4e9ace433492b658adb4e38878b	MD5	101940212368282795525448693043326438157	f	0	3	4838	a99888bf-e1c8-401b-a755-53ef7f002105
\N	16	9e72dc26665a18323be4f18e59683c3b	MD5	118441287885163367983994136115193185798	f	0	3	4150	8c0cd64c-047e-4182-98a2-b28671f7d528
\N	16	d75c651956f7272a605fb362c38a4162	MD5	35881649424022281361472154405900731810	f	0	3	6913	7d29847d-6143-4a08-91f1-84ddab82f98c
\N	16	c86493a26e4a22e4d3509da116f26ca9	MD5	90087368131273667488762515437922528378	t	0	2	67852	6d1d212d-f94a-4d27-942f-b3a6f27bf865
\N	16	004bd4499ef052353d5984c33eb42252	MD5	108765504659477465410396269390435310222	t	0	2	132550	16c9fb36-2b62-4e88-b7f1-264c227db582
\N	16	bd1a4f71ce45aa383dad2c1c2c5b778b	MD5	81636054349608154051894353918477149143	t	0	2	121005	10bb7ba1-0221-444d-af12-4ef6ca1affc3
\N	16	17f4bc9425e3ca8845f755bd2517e074	MD5	128707132903158102801327453157830303968	t	0	2	77750	b3b12b38-695a-402c-b1e8-3f42e26fa755
\N	16	b35ec8c0e6275f0c67317ae8968e085b	MD5	113446763371085585274501736823517620328	f	0	1	5557116	7a7c4e68-9f8e-4b25-88aa-b7642e53c76b
\N	16	07f01fc7220f760f50fde746af013fa6	MD5	117973839194417458582267788041803477907	t	0	2	161158	45d71b80-aa07-468e-b508-ab087c394aeb
\N	16	17c73481c7a09782fecf8e0d7af12444	MD5	72341094876476546495115458258310952380	t	0	2	111875	95589053-8ff6-4088-a327-85e300875f32
\N	16	66f3fb21f00274bc95e5560552ee22be	MD5	81039347788045964180167770764920202623	t	0	2	129041	785ff8cd-eaf7-40c4-8409-9a80f5a01c6d
\N	16	915f5509afb2d6338db4093137646296	MD5	148114466230493337389124997413531341652	t	0	2	129420	8b3691d8-dde6-4512-bdd2-92f5eaeb47fa
\N	16	7c57e98f91b2f99a95d687df953d7e2b	MD5	29467815473430457154235084744599426052	f	0	1	9739719	1b96bd99-3e47-4f72-8a9c-41e3c8281bbf
\N	16	937c686d40a5ddedc06d8ebf967e714f	MD5	148394858300038007263533474066928437676	f	0	3	5068	1be2d800-ff0f-4727-a737-410a5f23c79a
\N	16	7745cd32ccc1540bc62a2d5c92796754	MD5	142873223674513795346064804129521979234	f	0	1	3089400	acdc902a-8ef6-42bb-b3e0-0fcdf857d7bd
\N	16	4ed2479a82ac59fc4bc950cb096056dc	MD5	37675343418146954350369489343540180243	f	0	3	4144	d172edee-f13d-4095-812e-b46560b14436
\N	16	bde294086bd2cfc39e148cdc78937963	MD5	102270134071370835978297818006817986831	f	0	1	7713749	d2ada78c-e4b4-44b6-ae6c-de2f19d7a6ed
\N	16	721870d83b2d8cbab772724ade74a4f3	MD5	169307837972560928879663906791898395359	f	0	3	4174	3c2219e1-2aba-4858-b771-0da4ac35b418
\N	16	4514265c27ded188f844cee8a42130be	MD5	113040578518062520137904684440384675089	f	0	1	10002210	ef28e49e-8b42-49b5-8154-c1e13b376618
\N	16	2b9e54a0e7c0cbad6104cc013324c09e	MD5	88485339050946644505536380464825640306	f	0	3	3771	1dde7599-3b2c-49f5-ace4-51aeabf047ed
\N	16	dd1e9ea7715ed0339927c60d3df8e720	MD5	66870542042444438895490528513595517368	f	0	1	24469509	98b4567c-f60d-48a8-b40b-aa109b896617
\N	16	f8827f1891e119fd72f975ae4b028514	MD5	10372522394032527592849980117197494537	f	0	3	5811	49ad1cdd-954c-4cf1-8918-1cd7761d072a
\N	16	f9a87252f065371cc909c6566258048d	MD5	123325118270031259328834394440094136906	f	0	1	5941020	7df28185-e119-41ae-a6f0-8040cae712c8
\N	16	4b0d074f2d08bf13a574192e3e95c287	MD5	158442385553544066862928499700435284414	f	0	3	4377	0648c94a-8301-46dd-81e1-b1c8720f72ca
\N	16	aa12ab7e96500fc974bc020594dd1a60	MD5	52243875604199586416339264984046829403	t	0	2	62449	19b20ec1-9ab1-4fda-a3ae-66601633cb07
\N	16	113e881971852c00b69a71d5e38a358e	MD5	133646833108701877000974219059985064297	f	0	1	23163477	9cdc3539-a776-4d24-a8c9-af225aebeaf4
\N	16	fc71d73ab2dafdc9a0e6851e7e173688	MD5	106282905033062953992843609996645279846	t	0	2	80071	8c1442f9-46b5-484b-9d9b-9f3a8761810c
\N	16	3bb18c48e35e8e094cb10fb1f044ec7d	MD5	102123015183942482192083359412413811280	t	0	2	119957	87a8e209-c582-4259-9586-c0b2abad4611
\N	16	4400e5a979a90f14aed86236140dcee6	MD5	141225336170836676893966998335280052845	t	0	2	133697	7480d6bd-9a95-4d0c-8f22-e769baf2fca0
\N	16	294643aef5f3c8371b55e40fb2fa56c5	MD5	19570831774853142333521752776706046935	t	0	2	198726	cf2051c9-5e57-47c6-8fa2-baba200ac735
\N	16	d5cd9d883db483ccb8418866b4fe366e	MD5	34871062371447842180684095445623708767	f	0	1	12138026	0358ba2a-8854-4698-9435-6c8ec90af0b4
\N	16	2176f9e113a0716add9a8b7d13f56a65	MD5	72498654217782590701032035714506489756	t	0	2	114451	642a081e-e590-416a-a538-0dd135f0a3d7
\N	16	09396e6c13d239ec79620cb6b069e182	MD5	749583553693090045135063953963372254	t	0	2	160458	3102005b-110e-4743-9483-bc06b7d7c546
\N	16	da669c28facbe08f60b9106af5fd3e42	MD5	141822779093206921354225931572543597879	f	0	1	5112685	60aa899d-7eba-4202-a780-6db425f03e8c
\N	16	ebe0f8c354db17c3def66ff88ddddb35	MD5	107254783412526111070094429415789939055	f	0	1	14072542	31ad0de3-e86a-4535-9694-6f206e857d96
\N	16	59a5593041836c2869d3af9df6882509	MD5	108692268138279454113987354521300603507	f	0	1	8387727	514b31c8-3dd1-4a4b-b764-85fb7f7ab09c
\N	16	e6ebb698e30a605103ab51cb556524c4	MD5	118697478170127058137475470611077198583	f	0	1	32998221	5b5927be-37a7-4643-b553-89419b5a706d
\N	16	a2496ded560ef84a1a9dac2d949f5347	MD5	70675028402277095192784429731444865797	f	0	1	5054328	74d3fbca-f981-4a0d-a0ef-5631397f988a
\N	16	0cc85a4e244aea58117a1b8646fc8fce	MD5	103332999446490138021585930109881835731	f	0	1	14533508	ad73097b-7c92-425b-9482-c1b43c3d568b
\N	16	e33b958e1decf68d8cf301e3d3209594	MD5	162529581880876159943173453538100027123	t	0	2	40214	6473cd49-1948-4391-8616-a73fe1af01ca
\N	16	c1df8c0eeb7a2eb3ecda25a28bb18a85	MD5	42444843632069664386498747376415337927	t	0	2	120015	13a48304-1c13-43c2-813e-835a1b89cfea
\N	16	55626c308cf0c5fa564db6496f0148ab	MD5	62600723215018088011436989682712869783	t	0	2	62074	5250cc69-87ca-4ef9-8022-5fca19fd092a
\N	16	84c35daa89ed4d8f607e7af339b1da2d	MD5	57367664106538603469168423038961871089	t	0	2	139511	75b52b9d-9bc1-4c9e-b99e-e6e6914f9b74
\N	16	0defce91000549689b603085021d4517	MD5	107033161934152038548910605269249784321	f	0	1	1280837	563eb3fb-1600-46cf-86f9-98fdafc3b478
\N	16	1b1640e13b176018c8c7ab7e0c4563c8	MD5	86488541765845858376087232568395049449	t	0	1	133813	04aca341-8975-4406-b960-95542b8dff79
\N	16	12031af1f80e84878e2cda6d07414c63	MD5	50614429343470108518146137014089329392	t	0	2	109537	fecf442d-6eb8-4578-b194-7401b6ca6147
\N	16	05da4634c31ce6d1856b0801a3dd92d4	MD5	121008936616985253193484252181167592060	t	0	2	151442	de55033f-24a1-4b83-9b2c-e13cbc76fb92
\N	16	bb564b98101e8340a3391b9c12b7990e	MD5	57041073182234425725034268555991313321	t	0	2	142571	3ab19994-833d-493e-9c68-b71539f851e4
\N	16	1c59f72bb08032106054edee11b8ad07	MD5	114842682054605859976926384795375081945	f	0	1	15413436	6b5df0be-5101-4525-b6a2-a756c86056df
\N	16	f67c903fd3e17bb21326919691628a8b	MD5	46042220394431967834917360439199306779	f	0	1	23261993	6bc6311a-46c9-4954-b020-5ce23c722fec
\N	16	9b4a2f165e15063c4a139244468869ad	MD5	143965906247467635759024579921396071770	f	0	2	2605533	fccef367-c66f-4c8b-b5b1-6c0c0bc26f06
\N	16	e97a950b75915073892ba6c8bcafd64c	MD5	103171118786028125184842291989302371456	f	0	1	6122908	c4bd7804-502e-48f8-a12b-8b87d142393f
\N	16	535ca0cdab30ef173b51326f787a1339	MD5	86458853018666913817712738154163365140	f	0	1	4395952	81d538ed-1831-40bc-827c-1b7ea43eef30
\N	16	7cee6345994146d3140d90c844cb7b5b	MD5	88772384197542559099726694069541616652	f	0	1	7163118	8baccd65-9cbb-4638-9c41-52bab8ef13c4
\N	16	9c6f025b88f4641ce84d14a07db1f7dc	MD5	3828121306372765390580748325825502275	t	0	2	138919	5a041b16-cf3c-4730-91d3-cc92e9f94444
\N	16	b4cb3b569124e9ea32e43f7ed2c0b30d	MD5	148586144903361220992600870356563743992	f	0	1	1137580	ade000fc-2740-47e4-abc4-5f501ea69256
\N	16	f35567cb3879e43a8c877682faeba47d	MD5	112201957033380350333334806267476087504	t	0	2	122374	f25f59ff-bf38-4582-a8bb-50fef4729cc1
\N	16	93a114329b86c675f5d1ba6002cd90fd	MD5	64850995572186731495046650720782291673	f	0	1	6775478	271f93fb-6f2e-4766-bc39-af649c412eb4
\.


--
-- Data for Name: bitstreamformatregistry; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.bitstreamformatregistry (bitstream_format_id, mimetype, short_description, description, support_level, internal) FROM stdin;
1	application/octet-stream	Unknown	Unknown data format	0	f
2	text/plain; charset=utf-8	License	Item-specific license agreed upon to submission	1	t
3	text/html; charset=utf-8	CC License	Item-specific Creative Commons license agreed upon to submission	1	t
4	application/pdf	Adobe PDF	Adobe Portable Document Format	1	f
5	text/xml	XML	Extensible Markup Language	1	f
6	text/plain	Text	Plain Text	1	f
7	text/html	HTML	Hypertext Markup Language	1	f
8	text/css	CSS	Cascading Style Sheets	1	f
9	application/msword	Microsoft Word	Microsoft Word	1	f
10	application/vnd.openxmlformats-officedocument.wordprocessingml.document	Microsoft Word XML	Microsoft Word XML	1	f
11	application/vnd.ms-powerpoint	Microsoft Powerpoint	Microsoft Powerpoint	1	f
12	application/vnd.openxmlformats-officedocument.presentationml.presentation	Microsoft Powerpoint XML	Microsoft Powerpoint XML	1	f
13	application/vnd.ms-excel	Microsoft Excel	Microsoft Excel	1	f
14	application/vnd.openxmlformats-officedocument.spreadsheetml.sheet	Microsoft Excel XML	Microsoft Excel XML	1	f
15	application/marc	MARC	Machine-Readable Cataloging records	1	f
16	image/jpeg	JPEG	Joint Photographic Experts Group/JPEG File Interchange Format (JFIF)	1	f
17	image/gif	GIF	Graphics Interchange Format	1	f
18	image/png	image/png	Portable Network Graphics	1	f
19	image/tiff	TIFF	Tag Image File Format	1	f
20	audio/x-aiff	AIFF	Audio Interchange File Format	1	f
21	audio/basic	audio/basic	Basic Audio	1	f
22	audio/x-wav	WAV	Broadcase Wave Format	1	f
23	video/mpeg	MPEG	Moving Picture Experts Group	1	f
24	text/richtext	RTF	Rich Text Format	1	f
25	application/vnd.visio	Microsoft Visio	Microsoft Visio	1	f
26	application/x-filemaker	FMP3	Filemaker Pro	1	f
27	image/x-ms-bmp	BMP	Microsoft Windows bitmap	1	f
28	application/x-photoshop	Photoshop	Photoshop	1	f
29	application/postscript	Postscript	Postscript Files	1	f
30	video/quicktime	Video Quicktime	Video Quicktime	1	f
31	audio/x-mpeg	MPEG Audio	MPEG Audio	1	f
32	application/vnd.ms-project	Microsoft Project	Microsoft Project	1	f
33	application/mathematica	Mathematica	Mathematica Notebook	1	f
34	application/x-latex	LateX	LaTeX document	1	f
35	application/x-tex	TeX	Tex/LateX document	1	f
36	application/x-dvi	TeX dvi	TeX dvi format	1	f
37	application/sgml	SGML	SGML application (RFC 1874)	1	f
38	application/wordperfect5.1	WordPerfect	WordPerfect 5.1 document	1	f
39	audio/x-pn-realaudio	RealAudio	RealAudio file	1	f
40	image/x-photo-cd	Photo CD	Kodak Photo CD image	1	f
41	application/vnd.oasis.opendocument.text	OpenDocument Text	OpenDocument Text	1	f
42	application/vnd.oasis.opendocument.text-template	OpenDocument Text Template	OpenDocument Text Template	1	f
43	application/vnd.oasis.opendocument.text-web	OpenDocument HTML Template	OpenDocument HTML Template	1	f
44	application/vnd.oasis.opendocument.text-master	OpenDocument Master Document	OpenDocument Master Document	1	f
45	application/vnd.oasis.opendocument.graphics	OpenDocument Drawing	OpenDocument Drawing	1	f
46	application/vnd.oasis.opendocument.graphics-template	OpenDocument Drawing Template	OpenDocument Drawing Template	1	f
47	application/vnd.oasis.opendocument.presentation	OpenDocument Presentation	OpenDocument Presentation	1	f
48	application/vnd.oasis.opendocument.presentation-template	OpenDocument Presentation Template	OpenDocument Presentation Template	1	f
49	application/vnd.oasis.opendocument.spreadsheet	OpenDocument Spreadsheet	OpenDocument Spreadsheet	1	f
50	application/vnd.oasis.opendocument.spreadsheet-template	OpenDocument Spreadsheet Template	OpenDocument Spreadsheet Template	1	f
51	application/vnd.oasis.opendocument.chart	OpenDocument Chart	OpenDocument Chart	1	f
52	application/vnd.oasis.opendocument.formula	OpenDocument Formula	OpenDocument Formula	1	f
53	application/vnd.oasis.opendocument.database	OpenDocument Database	OpenDocument Database	1	f
54	application/vnd.oasis.opendocument.image	OpenDocument Image	OpenDocument Image	1	f
55	application/vnd.openofficeorg.extension	OpenOffice.org extension	OpenOffice.org extension (since OOo 2.1)	1	f
56	application/vnd.sun.xml.writer	Writer 6.0 documents	Writer 6.0 documents	1	f
57	application/vnd.sun.xml.writer.template	Writer 6.0 templates	Writer 6.0 templates	1	f
58	application/vnd.sun.xml.calc	Calc 6.0 spreadsheets	Calc 6.0 spreadsheets	1	f
59	application/vnd.sun.xml.calc.template	Calc 6.0 templates	Calc 6.0 templates	1	f
60	application/vnd.sun.xml.draw	Draw 6.0 documents	Draw 6.0 documents	1	f
61	application/vnd.sun.xml.draw.template	Draw 6.0 templates	Draw 6.0 templates	1	f
62	application/vnd.sun.xml.impress	Impress 6.0 presentations	Impress 6.0 presentations	1	f
63	application/vnd.sun.xml.impress.template	Impress 6.0 templates	Impress 6.0 templates	1	f
64	application/vnd.sun.xml.writer.global	Writer 6.0 global documents	Writer 6.0 global documents	1	f
65	application/vnd.sun.xml.math	Math 6.0 documents	Math 6.0 documents	1	f
66	application/vnd.stardivision.writer	StarWriter 5.x documents	StarWriter 5.x documents	1	f
67	application/vnd.stardivision.writer-global	StarWriter 5.x global documents	StarWriter 5.x global documents	1	f
68	application/vnd.stardivision.calc	StarCalc 5.x spreadsheets	StarCalc 5.x spreadsheets	1	f
69	application/vnd.stardivision.draw	StarDraw 5.x documents	StarDraw 5.x documents	1	f
70	application/vnd.stardivision.impress	StarImpress 5.x presentations	StarImpress 5.x presentations	1	f
71	application/vnd.stardivision.impress-packed	StarImpress Packed 5.x files	StarImpress Packed 5.x files	1	f
72	application/vnd.stardivision.math	StarMath 5.x documents	StarMath 5.x documents	1	f
73	application/vnd.stardivision.chart	StarChart 5.x documents	StarChart 5.x documents	1	f
74	application/vnd.stardivision.mail	StarMail 5.x mail files	StarMail 5.x mail files	1	f
75	application/rdf+xml; charset=utf-8	RDF XML	RDF serialized in XML	1	f
76	application/epub+zip	EPUB	Electronic publishing	1	f
\.


--
-- Name: bitstreamformatregistry_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.bitstreamformatregistry_seq', 76, true);


--
-- Data for Name: bundle; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.bundle (bundle_id, uuid, primary_bitstream_id) FROM stdin;
\N	ff09241d-855a-49c2-8fbc-45502c8b8af3	\N
\N	9ab336a9-ac0f-4cbd-9b75-d7a9688ce99a	\N
\N	a80c401c-0c0e-4822-b740-af9c3abfdf0d	\N
\N	0b8918a1-7938-4a16-adad-47cc659081a8	\N
\N	3b7d13a5-363f-47d1-8cd9-62916736446a	\N
\N	df393130-4c6e-4939-aa32-06db82f60c5e	\N
\N	49c37abb-eb40-4511-bfa4-85b47f4f9078	\N
\N	3f33561d-885f-4ada-bb9e-40909ce55a83	\N
\N	105ac278-02a6-41d7-aa6b-4e0573bf2ee7	\N
\N	120ef5da-fc4e-4952-b8a8-4ffd42fc6fe9	\N
\N	5a9aa0c7-bca9-4b61-acf6-087fd97eb722	\N
\N	b77baa82-dccc-436e-b001-15055196e25e	\N
\N	4d9f173b-7552-4326-ac76-a0950e387ec8	\N
\N	e6dd77b8-988c-415e-83c4-9e6003c237a7	\N
\N	8ba24c03-9683-4bd5-8182-63a1188df55e	\N
\N	9ba1ff9a-0530-4abb-aade-a84ee2415616	\N
\N	70fdd62c-343b-4d75-b628-2040c97479e8	\N
\N	86832dac-4fbe-42d9-8a8d-94a9ce22cf20	\N
\N	042e5ec3-7be3-4a30-9009-e6d3839bfda7	\N
\N	9ea9f933-ee16-4dbd-889d-fdced9321c03	\N
\N	4cf5e155-be37-4290-93fe-22e3edf55167	\N
\N	0ced5b26-bdcf-47af-96ba-588ad0784150	\N
\N	611b0593-f0d8-4a0c-b694-d3143e35a3c8	\N
\N	17130f2d-bc9c-412d-9e9b-6f17d2deaaef	\N
\N	7423f872-ff3a-417c-b5fd-0ab44a56d884	\N
\N	4e2f8ce5-121d-4f09-b736-953c01ffab7c	\N
\N	a8361706-0b42-4805-8f75-911f1b73b298	\N
\N	516667ff-c91e-40f5-95b5-c0905f6d9681	\N
\N	9b4bc286-450d-4ddf-aa38-90b226234686	\N
\N	e2c4c22c-eb00-425a-9cc1-b9240fd18311	\N
\N	65710ee6-0ba1-41d7-baf4-d488222918a7	\N
\N	3a6f9fd1-ada9-4a1f-a5b9-f4ee408c36d0	\N
\N	437a093f-a0eb-4947-9366-12e7cea4f579	\N
\N	f5322472-6bb0-4db5-b7c6-ff39f0f389bf	\N
\N	06fbd362-9e07-4867-977b-1971ef7e1812	\N
\N	a2621d19-9ee1-4e91-b431-9c56ff0a9a95	\N
\N	06956b32-551b-4839-8298-46656be0928e	\N
\N	317d384a-8bd7-443f-ae59-9b110bd89412	\N
\N	f9cb7f87-a781-4b0f-8a9a-7eb5bc501b65	\N
\N	435a868d-93c3-41ec-b2d4-8ba1ff771e1f	\N
\N	8d8ceac0-5b32-45c2-a928-32ebf9070558	\N
\N	0fd73a3a-ff0d-429c-a24e-4bc9443a54b4	\N
\N	78e9be50-f651-4538-8319-a6e2ca4c2d91	\N
\N	0bb280a7-63a0-459f-8e4b-c5473e9337ab	\N
\N	ef47138a-4950-44d5-a967-2247a54bd4ed	\N
\N	22de0971-5c94-408a-b79a-784e7cca0856	\N
\N	d5e54765-b028-4723-939d-670ae49d1292	\N
\N	a52a46a0-92c0-43f8-9387-bbad149a9a4e	\N
\N	88d5b1c1-f0d7-49c6-adbb-36e87c268f46	\N
\N	4b3a9584-97fb-4718-9534-f5028a1b99b8	\N
\N	61b28a3c-d6b7-4bc7-b304-570a3d6ec4fb	\N
\N	ffebcf7e-61b5-4acd-9cec-7919f7a1580a	\N
\N	85b21ccf-7fe9-4a85-99b8-3f14defd9024	\N
\N	a40bcc91-5bff-4767-a812-ec14e1da96b0	\N
\N	8431ac09-4f3a-43c3-aa3d-1138d3e7fd28	\N
\N	d1e98419-e25f-4d72-a6e3-5c38a98fbc72	\N
\N	9a62e23b-0d7c-47c5-9882-82055f97d477	\N
\N	8fb920ce-a656-49ff-a9b5-29f04ace2df9	\N
\N	d5cdecba-6e76-4615-972e-fb7166735f0a	\N
\N	0c1c8c49-87ee-4053-b1b8-078b031a4870	\N
\N	408036eb-460c-44f3-823c-0f4f21b5e7d8	\N
\N	42f9fb24-ef94-4d14-b9ce-c7fb2bb12c13	\N
\N	95248b9d-2a11-4f62-a952-f4ef8ecf6142	\N
\N	eb9ff9c5-5d9d-4de5-a5ea-0fc5f40e2594	\N
\N	f0be2af3-8f78-4b7e-908e-da13b7c8f998	\N
\N	1640fc10-07f2-4ac9-ad35-5ca970d7e3dc	\N
\N	9817e8d8-8eee-42b4-a188-b360ee9d1f3c	\N
\N	7a1434b7-6895-4f14-a80b-c2b1205bac55	\N
\N	a8fad082-f1f4-49f9-a73d-7df879ca8df3	\N
\N	ea1a91b4-37c3-4606-9f2a-bbe2e77dd621	\N
\N	cdb86a05-b0b4-497f-8808-534d330ef40f	\N
\N	7f71e243-6c60-4665-8f1e-cd04ea138d94	\N
\N	a7a81151-eac6-41ca-ac57-07c5f3e32100	\N
\N	18fd7b92-a579-4299-97ca-00c53e30065f	\N
\N	58114c56-4af2-4df8-9ccf-11f62861190d	\N
\N	b0af88a3-1267-44fa-a33e-e69f6652c53f	\N
\N	2cd4b643-8b70-4e10-9ae9-6ac90e6e82ac	\N
\N	db4868a4-e0d0-4d14-9f0b-aa32d6b0e8cf	\N
\.


--
-- Data for Name: bundle2bitstream; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.bundle2bitstream (bitstream_order_legacy, bundle_id, bitstream_id, bitstream_order) FROM stdin;
\N	ff09241d-855a-49c2-8fbc-45502c8b8af3	0e574c1b-c9b0-42bc-8ab0-117200a8116a	0
\N	a80c401c-0c0e-4822-b740-af9c3abfdf0d	5dc559b8-06ba-45a3-9924-f4edd9d834bf	0
\N	3b7d13a5-363f-47d1-8cd9-62916736446a	0c7568f7-0a7a-47cb-890b-45e76342b112	0
\N	49c37abb-eb40-4511-bfa4-85b47f4f9078	2211fbd7-3a2d-429d-bae7-ecab96049a46	0
\N	105ac278-02a6-41d7-aa6b-4e0573bf2ee7	cbced2d8-7ca1-40e2-9c14-b9673c4e78ef	0
\N	5a9aa0c7-bca9-4b61-acf6-087fd97eb722	a94555aa-4aab-4229-a822-94f5f8c35f2c	0
\N	4d9f173b-7552-4326-ac76-a0950e387ec8	dc0680b6-5534-4091-9619-f945e80a308b	0
\N	8ba24c03-9683-4bd5-8182-63a1188df55e	0107af4a-0e80-4d48-bceb-57e088cd92b0	0
\N	70fdd62c-343b-4d75-b628-2040c97479e8	df126add-167e-4004-a3e0-b8b0374f885d	0
\N	042e5ec3-7be3-4a30-9009-e6d3839bfda7	c168ef8c-6706-4530-8e60-0162cd97980c	0
\N	4cf5e155-be37-4290-93fe-22e3edf55167	d0aa8a78-9ce7-4527-8208-35d7b34fea8d	0
\N	611b0593-f0d8-4a0c-b694-d3143e35a3c8	001787ca-4021-4448-b6ed-6ff1d56076c0	0
\N	7423f872-ff3a-417c-b5fd-0ab44a56d884	7acced69-4137-4ae6-82aa-d425b7b12cbf	0
\N	a8361706-0b42-4805-8f75-911f1b73b298	512c54c6-fb9f-4351-a5b8-a15968510dd1	0
\N	9b4bc286-450d-4ddf-aa38-90b226234686	ef5c27a6-f687-441a-8947-cb07696025e3	0
\N	65710ee6-0ba1-41d7-baf4-d488222918a7	7a7c4e68-9f8e-4b25-88aa-b7642e53c76b	0
\N	437a093f-a0eb-4947-9366-12e7cea4f579	1b96bd99-3e47-4f72-8a9c-41e3c8281bbf	0
\N	06fbd362-9e07-4867-977b-1971ef7e1812	acdc902a-8ef6-42bb-b3e0-0fcdf857d7bd	0
\N	06956b32-551b-4839-8298-46656be0928e	d2ada78c-e4b4-44b6-ae6c-de2f19d7a6ed	0
\N	f9cb7f87-a781-4b0f-8a9a-7eb5bc501b65	ef28e49e-8b42-49b5-8154-c1e13b376618	0
\N	8d8ceac0-5b32-45c2-a928-32ebf9070558	98b4567c-f60d-48a8-b40b-aa109b896617	0
\N	78e9be50-f651-4538-8319-a6e2ca4c2d91	7df28185-e119-41ae-a6f0-8040cae712c8	0
\N	ef47138a-4950-44d5-a967-2247a54bd4ed	9cdc3539-a776-4d24-a8c9-af225aebeaf4	0
\N	d5e54765-b028-4723-939d-670ae49d1292	0358ba2a-8854-4698-9435-6c8ec90af0b4	0
\N	88d5b1c1-f0d7-49c6-adbb-36e87c268f46	60aa899d-7eba-4202-a780-6db425f03e8c	0
\N	61b28a3c-d6b7-4bc7-b304-570a3d6ec4fb	31ad0de3-e86a-4535-9694-6f206e857d96	0
\N	85b21ccf-7fe9-4a85-99b8-3f14defd9024	514b31c8-3dd1-4a4b-b764-85fb7f7ab09c	0
\N	8431ac09-4f3a-43c3-aa3d-1138d3e7fd28	5b5927be-37a7-4643-b553-89419b5a706d	0
\N	9a62e23b-0d7c-47c5-9882-82055f97d477	74d3fbca-f981-4a0d-a0ef-5631397f988a	0
\N	d5cdecba-6e76-4615-972e-fb7166735f0a	ad73097b-7c92-425b-9482-c1b43c3d568b	0
\N	408036eb-460c-44f3-823c-0f4f21b5e7d8	563eb3fb-1600-46cf-86f9-98fdafc3b478	0
\N	95248b9d-2a11-4f62-a952-f4ef8ecf6142	6b5df0be-5101-4525-b6a2-a756c86056df	0
\N	f0be2af3-8f78-4b7e-908e-da13b7c8f998	6bc6311a-46c9-4954-b020-5ce23c722fec	0
\N	7a1434b7-6895-4f14-a80b-c2b1205bac55	fccef367-c66f-4c8b-b5b1-6c0c0bc26f06	0
\N	a8fad082-f1f4-49f9-a73d-7df879ca8df3	c4bd7804-502e-48f8-a12b-8b87d142393f	0
\N	cdb86a05-b0b4-497f-8808-534d330ef40f	81d538ed-1831-40bc-827c-1b7ea43eef30	0
\N	a7a81151-eac6-41ca-ac57-07c5f3e32100	8baccd65-9cbb-4638-9c41-52bab8ef13c4	0
\N	58114c56-4af2-4df8-9ccf-11f62861190d	ade000fc-2740-47e4-abc4-5f501ea69256	0
\N	2cd4b643-8b70-4e10-9ae9-6ac90e6e82ac	271f93fb-6f2e-4766-bc39-af649c412eb4	0
\N	9ab336a9-ac0f-4cbd-9b75-d7a9688ce99a	17d71f15-eaf1-41da-85c3-a1ac3129ea60	0
\N	0b8918a1-7938-4a16-adad-47cc659081a8	d145f27a-a203-4663-915f-7d5718fbc387	0
\N	df393130-4c6e-4939-aa32-06db82f60c5e	46b7d0d6-e7be-499d-ae60-ec10bc7301f2	0
\N	120ef5da-fc4e-4952-b8a8-4ffd42fc6fe9	608da05e-be8e-4edd-ba48-b952efd151cf	0
\N	86832dac-4fbe-42d9-8a8d-94a9ce22cf20	ed372ab2-cb41-49a5-95ed-3558cdd00a13	0
\N	9ea9f933-ee16-4dbd-889d-fdced9321c03	9f0fcbd3-5455-484e-9582-d996bbd00a4f	0
\N	0ced5b26-bdcf-47af-96ba-588ad0784150	a0450d8b-5720-4aca-9838-d94a779e68d6	0
\N	17130f2d-bc9c-412d-9e9b-6f17d2deaaef	089f0a09-8f7b-4504-a99a-a13113cb70d7	0
\N	516667ff-c91e-40f5-95b5-c0905f6d9681	14704a8d-e5a9-4374-9ca5-41a0621d600c	0
\N	e2c4c22c-eb00-425a-9cc1-b9240fd18311	16e077ef-74a7-4622-8343-bbd7f22e91d6	0
\N	3a6f9fd1-ada9-4a1f-a5b9-f4ee408c36d0	d91ce649-f50c-4122-8ad8-0c713d5ac137	0
\N	a2621d19-9ee1-4e91-b431-9c56ff0a9a95	613ee361-f8fb-4ff5-9c55-38f0cb83be45	0
\N	317d384a-8bd7-443f-ae59-9b110bd89412	e7bd4f9d-c802-498d-9aea-c3240c40233b	0
\N	435a868d-93c3-41ec-b2d4-8ba1ff771e1f	d4cc7466-9447-45fe-8089-d8b8f73341a3	0
\N	0bb280a7-63a0-459f-8e4b-c5473e9337ab	a99888bf-e1c8-401b-a755-53ef7f002105	0
\N	4b3a9584-97fb-4718-9534-f5028a1b99b8	8c0cd64c-047e-4182-98a2-b28671f7d528	0
\N	a40bcc91-5bff-4767-a812-ec14e1da96b0	7d29847d-6143-4a08-91f1-84ddab82f98c	0
\N	9817e8d8-8eee-42b4-a188-b360ee9d1f3c	1be2d800-ff0f-4727-a737-410a5f23c79a	0
\N	ea1a91b4-37c3-4606-9f2a-bbe2e77dd621	d172edee-f13d-4095-812e-b46560b14436	0
\N	7f71e243-6c60-4665-8f1e-cd04ea138d94	3c2219e1-2aba-4858-b771-0da4ac35b418	0
\N	18fd7b92-a579-4299-97ca-00c53e30065f	1dde7599-3b2c-49f5-ace4-51aeabf047ed	0
\N	b0af88a3-1267-44fa-a33e-e69f6652c53f	49ad1cdd-954c-4cf1-8918-1cd7761d072a	0
\N	db4868a4-e0d0-4d14-9f0b-aa32d6b0e8cf	0648c94a-8301-46dd-81e1-b1c8720f72ca	0
\.


--
-- Data for Name: checksum_history; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.checksum_history (check_id, process_start_date, process_end_date, checksum_expected, checksum_calculated, result, bitstream_id) FROM stdin;
\.


--
-- Name: checksum_history_check_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.checksum_history_check_id_seq', 1, false);


--
-- Data for Name: checksum_results; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.checksum_results (result_code, result_description) FROM stdin;
INVALID_HISTORY	Install of the cheksum checking code do not consider this history as valid
BITSTREAM_NOT_FOUND	The bitstream could not be found
CHECKSUM_MATCH	Current checksum matched previous checksum
CHECKSUM_NO_MATCH	Current checksum does not match previous checksum
CHECKSUM_PREV_NOT_FOUND	Previous checksum was not found: no comparison possible
BITSTREAM_INFO_NOT_FOUND	Bitstream info not found
CHECKSUM_ALGORITHM_INVALID	Invalid checksum algorithm
BITSTREAM_NOT_PROCESSED	Bitstream marked to_be_processed=false
BITSTREAM_MARKED_DELETED	Bitstream marked deleted in bitstream table
\.


--
-- Data for Name: collection; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.collection (collection_id, uuid, workflow_step_1, workflow_step_2, workflow_step_3, submitter, template_item_id, logo_bitstream_id, admin) FROM stdin;
\N	608a1f61-7aa3-4e18-9ff9-ef7a767412c4	\N	\N	\N	\N	\N	\N	\N
\.


--
-- Data for Name: collection2item; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.collection2item (collection_id, item_id) FROM stdin;
608a1f61-7aa3-4e18-9ff9-ef7a767412c4	d6be9004-bec3-4705-9a4e-f22796cd979e
608a1f61-7aa3-4e18-9ff9-ef7a767412c4	1647a00d-03d4-484f-9747-7f10f7eb2088
608a1f61-7aa3-4e18-9ff9-ef7a767412c4	6042b9c6-0f1a-4714-863e-0208d96df43a
608a1f61-7aa3-4e18-9ff9-ef7a767412c4	4e20305a-a171-4533-bb0d-0fde80140a82
608a1f61-7aa3-4e18-9ff9-ef7a767412c4	f0ea3089-84e1-4a9a-9817-16d15100fb54
608a1f61-7aa3-4e18-9ff9-ef7a767412c4	edbc5bff-4b36-4b31-b08b-ef5b67d01a74
608a1f61-7aa3-4e18-9ff9-ef7a767412c4	f5487302-92d0-4914-89f6-2190c49f4ced
608a1f61-7aa3-4e18-9ff9-ef7a767412c4	b8684970-4418-4f5b-a99a-c46ed5721710
608a1f61-7aa3-4e18-9ff9-ef7a767412c4	f0c85891-e655-4e8e-a6ba-eabba6fdfc97
608a1f61-7aa3-4e18-9ff9-ef7a767412c4	af4b4244-1e85-4b33-9ca0-c267b1130df0
608a1f61-7aa3-4e18-9ff9-ef7a767412c4	b17e6dc6-cd53-4646-b790-06d1a12ee1ab
608a1f61-7aa3-4e18-9ff9-ef7a767412c4	3b3166f9-bb45-486b-bb08-6e2e08901cd4
608a1f61-7aa3-4e18-9ff9-ef7a767412c4	c82a1191-3a63-4667-bfda-6080261a4069
608a1f61-7aa3-4e18-9ff9-ef7a767412c4	2a63b298-96d5-4ded-a0fc-e7ca3bcff831
608a1f61-7aa3-4e18-9ff9-ef7a767412c4	23356d3d-62c2-49f3-a1cd-e51531698402
608a1f61-7aa3-4e18-9ff9-ef7a767412c4	6a7ea32d-9b1f-46c2-a002-75292eef9a8f
608a1f61-7aa3-4e18-9ff9-ef7a767412c4	e34bee2e-ff66-4fda-8ef0-a70a9cc27139
608a1f61-7aa3-4e18-9ff9-ef7a767412c4	5cc3c183-a750-4b2a-8d8d-d4e4fdcc31d7
608a1f61-7aa3-4e18-9ff9-ef7a767412c4	987f4af4-d57e-4f67-b3d3-0513b13bf9f2
608a1f61-7aa3-4e18-9ff9-ef7a767412c4	b0e86f74-1ff4-495d-827b-0d8b4f1c9d4b
608a1f61-7aa3-4e18-9ff9-ef7a767412c4	68370f47-347b-40f5-a0bd-4cc2c6119c8e
608a1f61-7aa3-4e18-9ff9-ef7a767412c4	65396002-d1d3-4237-83ee-52d2dc506bd5
608a1f61-7aa3-4e18-9ff9-ef7a767412c4	5affab90-9b3a-4a32-aea4-15fbf5edaf17
608a1f61-7aa3-4e18-9ff9-ef7a767412c4	7d0a10d2-1ace-4694-b908-79630b8e0b78
608a1f61-7aa3-4e18-9ff9-ef7a767412c4	adad82ef-4c7d-4b61-b07a-4684c037320e
608a1f61-7aa3-4e18-9ff9-ef7a767412c4	2f3cc1e7-2490-427e-b00f-241dcab457a2
608a1f61-7aa3-4e18-9ff9-ef7a767412c4	09ec0ef8-ac24-4a29-a340-261df0304de8
608a1f61-7aa3-4e18-9ff9-ef7a767412c4	d6994539-a007-4084-a892-2620add43f25
608a1f61-7aa3-4e18-9ff9-ef7a767412c4	d3ed1b45-421a-47cf-b7a3-333df5f5599e
608a1f61-7aa3-4e18-9ff9-ef7a767412c4	51b13546-800a-44d8-81a1-f84086a43b9c
608a1f61-7aa3-4e18-9ff9-ef7a767412c4	4fc27f14-159f-46ec-90fe-9dfacfbd3632
608a1f61-7aa3-4e18-9ff9-ef7a767412c4	2ff5657d-1e3c-46f3-b842-37c0c6ee32e1
608a1f61-7aa3-4e18-9ff9-ef7a767412c4	02e74364-56c7-4094-83cd-164c8db70bfb
608a1f61-7aa3-4e18-9ff9-ef7a767412c4	e729bb52-e369-4170-a38c-a011feddaedb
608a1f61-7aa3-4e18-9ff9-ef7a767412c4	b49f6ec8-5476-4b8c-8eab-63f99a7d46b2
608a1f61-7aa3-4e18-9ff9-ef7a767412c4	97b1eb6d-cf2f-41bb-8943-bb70f042485a
608a1f61-7aa3-4e18-9ff9-ef7a767412c4	c0b68a77-7569-45c4-a10b-2d3fca4fed29
608a1f61-7aa3-4e18-9ff9-ef7a767412c4	6ef6ce81-f0f0-4345-8faa-081139d4e475
608a1f61-7aa3-4e18-9ff9-ef7a767412c4	16c0c95b-6b04-4f57-9c5c-03c975d4daf4
\.


--
-- Data for Name: community; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.community (community_id, uuid, admin, logo_bitstream_id) FROM stdin;
\N	6bbf5702-dd70-4e11-9ae9-bb1800b8f917	\N	\N
\.


--
-- Data for Name: community2collection; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.community2collection (collection_id, community_id) FROM stdin;
608a1f61-7aa3-4e18-9ff9-ef7a767412c4	6bbf5702-dd70-4e11-9ae9-bb1800b8f917
\.


--
-- Data for Name: community2community; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.community2community (parent_comm_id, child_comm_id) FROM stdin;
\.


--
-- Data for Name: doi; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.doi (doi_id, doi, resource_type_id, resource_id, status, dspace_object) FROM stdin;
\.


--
-- Name: doi_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.doi_seq', 1, false);


--
-- Data for Name: dspaceobject; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.dspaceobject (uuid) FROM stdin;
6f68478b-5ace-412d-838a-fd0e5c67581a
bcf9bae9-fb63-42cd-acd0-96df844ab078
d5ff6c8f-6c64-474b-89fc-2cd0f1327c13
41a39b48-a9ef-41c6-8aaf-98870d995b04
6bbf5702-dd70-4e11-9ae9-bb1800b8f917
608a1f61-7aa3-4e18-9ff9-ef7a767412c4
d6be9004-bec3-4705-9a4e-f22796cd979e
ff09241d-855a-49c2-8fbc-45502c8b8af3
0e574c1b-c9b0-42bc-8ab0-117200a8116a
9ab336a9-ac0f-4cbd-9b75-d7a9688ce99a
abb176ea-5c14-4080-a188-ecadb81b0b76
1647a00d-03d4-484f-9747-7f10f7eb2088
a80c401c-0c0e-4822-b740-af9c3abfdf0d
5dc559b8-06ba-45a3-9924-f4edd9d834bf
0b8918a1-7938-4a16-adad-47cc659081a8
adfc389d-5537-472c-9a51-4f1bd18b4888
6042b9c6-0f1a-4714-863e-0208d96df43a
3b7d13a5-363f-47d1-8cd9-62916736446a
0c7568f7-0a7a-47cb-890b-45e76342b112
df393130-4c6e-4939-aa32-06db82f60c5e
cd7ec348-a758-43d9-9cfa-dc1bd4f43036
4e20305a-a171-4533-bb0d-0fde80140a82
49c37abb-eb40-4511-bfa4-85b47f4f9078
2211fbd7-3a2d-429d-bae7-ecab96049a46
3f33561d-885f-4ada-bb9e-40909ce55a83
f4792a10-994e-470f-a2f6-c24017cc93cb
f0ea3089-84e1-4a9a-9817-16d15100fb54
105ac278-02a6-41d7-aa6b-4e0573bf2ee7
cbced2d8-7ca1-40e2-9c14-b9673c4e78ef
120ef5da-fc4e-4952-b8a8-4ffd42fc6fe9
19c8f7f2-27e1-4c00-b1ed-7335499e13d9
edbc5bff-4b36-4b31-b08b-ef5b67d01a74
5a9aa0c7-bca9-4b61-acf6-087fd97eb722
a94555aa-4aab-4229-a822-94f5f8c35f2c
b77baa82-dccc-436e-b001-15055196e25e
80d5242e-9daa-4a21-be6e-e461263c49b4
f5487302-92d0-4914-89f6-2190c49f4ced
4d9f173b-7552-4326-ac76-a0950e387ec8
dc0680b6-5534-4091-9619-f945e80a308b
e6dd77b8-988c-415e-83c4-9e6003c237a7
3ff42a9b-4597-44ae-91aa-a5c6b087e14c
b8684970-4418-4f5b-a99a-c46ed5721710
8ba24c03-9683-4bd5-8182-63a1188df55e
0107af4a-0e80-4d48-bceb-57e088cd92b0
9ba1ff9a-0530-4abb-aade-a84ee2415616
7d3525be-a86f-455c-810a-10f048c124d0
f0c85891-e655-4e8e-a6ba-eabba6fdfc97
70fdd62c-343b-4d75-b628-2040c97479e8
df126add-167e-4004-a3e0-b8b0374f885d
86832dac-4fbe-42d9-8a8d-94a9ce22cf20
19d68051-321e-4f01-9fc8-bbd38ffbbf82
af4b4244-1e85-4b33-9ca0-c267b1130df0
042e5ec3-7be3-4a30-9009-e6d3839bfda7
c168ef8c-6706-4530-8e60-0162cd97980c
9ea9f933-ee16-4dbd-889d-fdced9321c03
b1d0277b-fd8e-4fa3-8fa9-b19ed0a53d56
b17e6dc6-cd53-4646-b790-06d1a12ee1ab
4cf5e155-be37-4290-93fe-22e3edf55167
d0aa8a78-9ce7-4527-8208-35d7b34fea8d
0ced5b26-bdcf-47af-96ba-588ad0784150
37c0a70b-6d40-48fe-a528-765a5f6d86ca
3b3166f9-bb45-486b-bb08-6e2e08901cd4
611b0593-f0d8-4a0c-b694-d3143e35a3c8
001787ca-4021-4448-b6ed-6ff1d56076c0
17130f2d-bc9c-412d-9e9b-6f17d2deaaef
95fb37f3-03ae-4005-8266-0e2bad4d3981
c82a1191-3a63-4667-bfda-6080261a4069
7423f872-ff3a-417c-b5fd-0ab44a56d884
7acced69-4137-4ae6-82aa-d425b7b12cbf
4e2f8ce5-121d-4f09-b736-953c01ffab7c
ee62897c-32d2-4b1b-944c-21b83c509d68
2a63b298-96d5-4ded-a0fc-e7ca3bcff831
a8361706-0b42-4805-8f75-911f1b73b298
512c54c6-fb9f-4351-a5b8-a15968510dd1
516667ff-c91e-40f5-95b5-c0905f6d9681
cefd365e-cc38-49bf-bc47-01718da026b7
23356d3d-62c2-49f3-a1cd-e51531698402
9b4bc286-450d-4ddf-aa38-90b226234686
ef5c27a6-f687-441a-8947-cb07696025e3
e2c4c22c-eb00-425a-9cc1-b9240fd18311
6d1d212d-f94a-4d27-942f-b3a6f27bf865
6a7ea32d-9b1f-46c2-a002-75292eef9a8f
65710ee6-0ba1-41d7-baf4-d488222918a7
7a7c4e68-9f8e-4b25-88aa-b7642e53c76b
3a6f9fd1-ada9-4a1f-a5b9-f4ee408c36d0
16c9fb36-2b62-4e88-b7f1-264c227db582
e34bee2e-ff66-4fda-8ef0-a70a9cc27139
437a093f-a0eb-4947-9366-12e7cea4f579
1b96bd99-3e47-4f72-8a9c-41e3c8281bbf
f5322472-6bb0-4db5-b7c6-ff39f0f389bf
10bb7ba1-0221-444d-af12-4ef6ca1affc3
5cc3c183-a750-4b2a-8d8d-d4e4fdcc31d7
06fbd362-9e07-4867-977b-1971ef7e1812
acdc902a-8ef6-42bb-b3e0-0fcdf857d7bd
a2621d19-9ee1-4e91-b431-9c56ff0a9a95
b3b12b38-695a-402c-b1e8-3f42e26fa755
987f4af4-d57e-4f67-b3d3-0513b13bf9f2
06956b32-551b-4839-8298-46656be0928e
d2ada78c-e4b4-44b6-ae6c-de2f19d7a6ed
317d384a-8bd7-443f-ae59-9b110bd89412
45d71b80-aa07-468e-b508-ab087c394aeb
b0e86f74-1ff4-495d-827b-0d8b4f1c9d4b
f9cb7f87-a781-4b0f-8a9a-7eb5bc501b65
ef28e49e-8b42-49b5-8154-c1e13b376618
435a868d-93c3-41ec-b2d4-8ba1ff771e1f
95589053-8ff6-4088-a327-85e300875f32
68370f47-347b-40f5-a0bd-4cc2c6119c8e
8d8ceac0-5b32-45c2-a928-32ebf9070558
98b4567c-f60d-48a8-b40b-aa109b896617
0fd73a3a-ff0d-429c-a24e-4bc9443a54b4
785ff8cd-eaf7-40c4-8409-9a80f5a01c6d
65396002-d1d3-4237-83ee-52d2dc506bd5
78e9be50-f651-4538-8319-a6e2ca4c2d91
7df28185-e119-41ae-a6f0-8040cae712c8
0bb280a7-63a0-459f-8e4b-c5473e9337ab
8b3691d8-dde6-4512-bdd2-92f5eaeb47fa
5affab90-9b3a-4a32-aea4-15fbf5edaf17
ef47138a-4950-44d5-a967-2247a54bd4ed
9cdc3539-a776-4d24-a8c9-af225aebeaf4
22de0971-5c94-408a-b79a-784e7cca0856
19b20ec1-9ab1-4fda-a3ae-66601633cb07
7d0a10d2-1ace-4694-b908-79630b8e0b78
d5e54765-b028-4723-939d-670ae49d1292
0358ba2a-8854-4698-9435-6c8ec90af0b4
a52a46a0-92c0-43f8-9387-bbad149a9a4e
8c1442f9-46b5-484b-9d9b-9f3a8761810c
adad82ef-4c7d-4b61-b07a-4684c037320e
88d5b1c1-f0d7-49c6-adbb-36e87c268f46
60aa899d-7eba-4202-a780-6db425f03e8c
4b3a9584-97fb-4718-9534-f5028a1b99b8
87a8e209-c582-4259-9586-c0b2abad4611
2f3cc1e7-2490-427e-b00f-241dcab457a2
61b28a3c-d6b7-4bc7-b304-570a3d6ec4fb
31ad0de3-e86a-4535-9694-6f206e857d96
ffebcf7e-61b5-4acd-9cec-7919f7a1580a
7480d6bd-9a95-4d0c-8f22-e769baf2fca0
09ec0ef8-ac24-4a29-a340-261df0304de8
85b21ccf-7fe9-4a85-99b8-3f14defd9024
514b31c8-3dd1-4a4b-b764-85fb7f7ab09c
a40bcc91-5bff-4767-a812-ec14e1da96b0
cf2051c9-5e57-47c6-8fa2-baba200ac735
d6994539-a007-4084-a892-2620add43f25
8431ac09-4f3a-43c3-aa3d-1138d3e7fd28
5b5927be-37a7-4643-b553-89419b5a706d
d1e98419-e25f-4d72-a6e3-5c38a98fbc72
642a081e-e590-416a-a538-0dd135f0a3d7
d3ed1b45-421a-47cf-b7a3-333df5f5599e
9a62e23b-0d7c-47c5-9882-82055f97d477
74d3fbca-f981-4a0d-a0ef-5631397f988a
8fb920ce-a656-49ff-a9b5-29f04ace2df9
3102005b-110e-4743-9483-bc06b7d7c546
51b13546-800a-44d8-81a1-f84086a43b9c
d5cdecba-6e76-4615-972e-fb7166735f0a
ad73097b-7c92-425b-9482-c1b43c3d568b
0c1c8c49-87ee-4053-b1b8-078b031a4870
6473cd49-1948-4391-8616-a73fe1af01ca
4fc27f14-159f-46ec-90fe-9dfacfbd3632
408036eb-460c-44f3-823c-0f4f21b5e7d8
563eb3fb-1600-46cf-86f9-98fdafc3b478
42f9fb24-ef94-4d14-b9ce-c7fb2bb12c13
13a48304-1c13-43c2-813e-835a1b89cfea
2ff5657d-1e3c-46f3-b842-37c0c6ee32e1
95248b9d-2a11-4f62-a952-f4ef8ecf6142
6b5df0be-5101-4525-b6a2-a756c86056df
eb9ff9c5-5d9d-4de5-a5ea-0fc5f40e2594
5250cc69-87ca-4ef9-8022-5fca19fd092a
02e74364-56c7-4094-83cd-164c8db70bfb
f0be2af3-8f78-4b7e-908e-da13b7c8f998
6bc6311a-46c9-4954-b020-5ce23c722fec
1640fc10-07f2-4ac9-ad35-5ca970d7e3dc
75b52b9d-9bc1-4c9e-b99e-e6e6914f9b74
e729bb52-e369-4170-a38c-a011feddaedb
9817e8d8-8eee-42b4-a188-b360ee9d1f3c
04aca341-8975-4406-b960-95542b8dff79
7a1434b7-6895-4f14-a80b-c2b1205bac55
fccef367-c66f-4c8b-b5b1-6c0c0bc26f06
b49f6ec8-5476-4b8c-8eab-63f99a7d46b2
a8fad082-f1f4-49f9-a73d-7df879ca8df3
c4bd7804-502e-48f8-a12b-8b87d142393f
ea1a91b4-37c3-4606-9f2a-bbe2e77dd621
fecf442d-6eb8-4578-b194-7401b6ca6147
97b1eb6d-cf2f-41bb-8943-bb70f042485a
cdb86a05-b0b4-497f-8808-534d330ef40f
81d538ed-1831-40bc-827c-1b7ea43eef30
7f71e243-6c60-4665-8f1e-cd04ea138d94
de55033f-24a1-4b83-9b2c-e13cbc76fb92
c0b68a77-7569-45c4-a10b-2d3fca4fed29
a7a81151-eac6-41ca-ac57-07c5f3e32100
8baccd65-9cbb-4638-9c41-52bab8ef13c4
18fd7b92-a579-4299-97ca-00c53e30065f
3ab19994-833d-493e-9c68-b71539f851e4
6ef6ce81-f0f0-4345-8faa-081139d4e475
58114c56-4af2-4df8-9ccf-11f62861190d
ade000fc-2740-47e4-abc4-5f501ea69256
b0af88a3-1267-44fa-a33e-e69f6652c53f
5a041b16-cf3c-4730-91d3-cc92e9f94444
16c0c95b-6b04-4f57-9c5c-03c975d4daf4
2cd4b643-8b70-4e10-9ae9-6ac90e6e82ac
271f93fb-6f2e-4766-bc39-af649c412eb4
db4868a4-e0d0-4d14-9f0b-aa32d6b0e8cf
f25f59ff-bf38-4582-a8bb-50fef4729cc1
17d71f15-eaf1-41da-85c3-a1ac3129ea60
d145f27a-a203-4663-915f-7d5718fbc387
46b7d0d6-e7be-499d-ae60-ec10bc7301f2
608da05e-be8e-4edd-ba48-b952efd151cf
ed372ab2-cb41-49a5-95ed-3558cdd00a13
9f0fcbd3-5455-484e-9582-d996bbd00a4f
a0450d8b-5720-4aca-9838-d94a779e68d6
089f0a09-8f7b-4504-a99a-a13113cb70d7
14704a8d-e5a9-4374-9ca5-41a0621d600c
16e077ef-74a7-4622-8343-bbd7f22e91d6
d91ce649-f50c-4122-8ad8-0c713d5ac137
613ee361-f8fb-4ff5-9c55-38f0cb83be45
e7bd4f9d-c802-498d-9aea-c3240c40233b
d4cc7466-9447-45fe-8089-d8b8f73341a3
a99888bf-e1c8-401b-a755-53ef7f002105
8c0cd64c-047e-4182-98a2-b28671f7d528
7d29847d-6143-4a08-91f1-84ddab82f98c
1be2d800-ff0f-4727-a737-410a5f23c79a
d172edee-f13d-4095-812e-b46560b14436
3c2219e1-2aba-4858-b771-0da4ac35b418
1dde7599-3b2c-49f5-ace4-51aeabf047ed
49ad1cdd-954c-4cf1-8918-1cd7761d072a
0648c94a-8301-46dd-81e1-b1c8720f72ca
0a1b1544-c449-4d3c-954e-eacbf84f3e48
04be2760-8cdd-462c-b9cd-fb60e862c136
09793dde-5685-4605-828a-10313dbc2a1d
\.


--
-- Data for Name: eperson; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.eperson (eperson_id, email, password, can_log_in, require_certificate, self_registered, last_active, sub_frequency, netid, salt, digest_algorithm, uuid) FROM stdin;
\N	ying.jin@rice.edu	\N	t	f	f	2019-07-19 08:59:15.061	\N	yj4	\N	\N	0a1b1544-c449-4d3c-954e-eacbf84f3e48
\N	ualas@rice.edu	\N	t	f	f	2019-07-19 11:58:39.162	\N	ubr1	\N	\N	09793dde-5685-4605-828a-10313dbc2a1d
\N	mpr1@rice.edu	\N	t	f	f	2019-07-22 12:08:27.138	\N	mpr1	\N	\N	04be2760-8cdd-462c-b9cd-fb60e862c136
\N	yj4@rice.edu	2b4edbea09e505d5452d92e2a3f44195850af35f3c1b615cb965fc2df704f14851858815a210fecbf7c31aadbdcab4a36adaa9bb08ee472952befd0d7cb82564	t	f	f	2019-08-13 08:57:45.096	\N	\N	e8b5c80541e0a7e5968914691ecabede	SHA-512	41a39b48-a9ef-41c6-8aaf-98870d995b04
\.


--
-- Data for Name: epersongroup; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.epersongroup (eperson_group_id, uuid, permanent, name) FROM stdin;
\N	6f68478b-5ace-412d-838a-fd0e5c67581a	t	Anonymous
\N	bcf9bae9-fb63-42cd-acd0-96df844ab078	t	Administrator
\.


--
-- Data for Name: epersongroup2eperson; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.epersongroup2eperson (eperson_group_id, eperson_id) FROM stdin;
bcf9bae9-fb63-42cd-acd0-96df844ab078	0a1b1544-c449-4d3c-954e-eacbf84f3e48
bcf9bae9-fb63-42cd-acd0-96df844ab078	04be2760-8cdd-462c-b9cd-fb60e862c136
bcf9bae9-fb63-42cd-acd0-96df844ab078	41a39b48-a9ef-41c6-8aaf-98870d995b04
bcf9bae9-fb63-42cd-acd0-96df844ab078	09793dde-5685-4605-828a-10313dbc2a1d
\.


--
-- Data for Name: epersongroup2workspaceitem; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.epersongroup2workspaceitem (workspace_item_id, eperson_group_id) FROM stdin;
\.


--
-- Data for Name: fileextension; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.fileextension (file_extension_id, bitstream_format_id, extension) FROM stdin;
1	4	pdf
2	5	xml
3	6	txt
4	6	asc
5	7	htm
6	7	html
7	8	css
8	9	doc
9	10	docx
10	11	ppt
11	12	pptx
12	13	xls
13	14	xlsx
14	16	jpeg
15	16	jpg
16	17	gif
17	18	png
18	19	tiff
19	19	tif
20	20	aiff
21	20	aif
22	20	aifc
23	21	au
24	21	snd
25	22	wav
26	23	mpeg
27	23	mpg
28	23	mpe
29	24	rtf
30	25	vsd
31	26	fm
32	27	bmp
33	28	psd
34	28	pdd
35	29	ps
36	29	eps
37	29	ai
38	30	mov
39	30	qt
40	31	mpa
41	31	abs
42	31	mpega
43	32	mpp
44	32	mpx
45	32	mpd
46	33	ma
47	34	latex
48	35	tex
49	36	dvi
50	37	sgm
51	37	sgml
52	38	wpd
53	39	ra
54	39	ram
55	40	pcd
56	41	odt
57	42	ott
58	43	oth
59	44	odm
60	45	odg
61	46	otg
62	47	odp
63	48	otp
64	49	ods
65	50	ots
66	51	odc
67	52	odf
68	53	odb
69	54	odi
70	55	oxt
71	56	sxw
72	57	stw
73	58	sxc
74	59	stc
75	60	sxd
76	61	std
77	62	sxi
78	63	sti
79	64	sxg
80	65	sxm
81	66	sdw
82	67	sgl
83	68	sdc
84	69	sda
85	70	sdd
86	71	sdp
87	72	smf
88	73	sds
89	74	sdm
90	75	rdf
91	76	epub
\.


--
-- Name: fileextension_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.fileextension_seq', 91, true);


--
-- Data for Name: group2group; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.group2group (parent_id, child_id) FROM stdin;
\.


--
-- Data for Name: group2groupcache; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.group2groupcache (parent_id, child_id) FROM stdin;
\.


--
-- Data for Name: handle; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.handle (handle_id, handle, resource_type_id, resource_legacy_id, resource_id) FROM stdin;
1	20.500.12156.1/0	5	\N	d5ff6c8f-6c64-474b-89fc-2cd0f1327c13
2	20.500.12156.1/1	4	\N	6bbf5702-dd70-4e11-9ae9-bb1800b8f917
3	20.500.12156.1/2	3	\N	608a1f61-7aa3-4e18-9ff9-ef7a767412c4
4	20.500.12156.1/2058	2	\N	d6be9004-bec3-4705-9a4e-f22796cd979e
5	20.500.12156.1/2413	2	\N	1647a00d-03d4-484f-9747-7f10f7eb2088
6	20.500.12156.1/5276	2	\N	6042b9c6-0f1a-4714-863e-0208d96df43a
7	20.500.12156.1/4651	2	\N	4e20305a-a171-4533-bb0d-0fde80140a82
8	20.500.12156.1/2514	2	\N	f0ea3089-84e1-4a9a-9817-16d15100fb54
9	20.500.12156.1/2741	2	\N	edbc5bff-4b36-4b31-b08b-ef5b67d01a74
10	20.500.12156.1/2747	2	\N	f5487302-92d0-4914-89f6-2190c49f4ced
11	20.500.12156.1/4778	2	\N	b8684970-4418-4f5b-a99a-c46ed5721710
12	20.500.12156.1/4772	2	\N	f0c85891-e655-4e8e-a6ba-eabba6fdfc97
13	20.500.12156.1/2028	2	\N	af4b4244-1e85-4b33-9ca0-c267b1130df0
14	20.500.12156.1/2060	2	\N	b17e6dc6-cd53-4646-b790-06d1a12ee1ab
15	20.500.12156.1/5716	2	\N	3b3166f9-bb45-486b-bb08-6e2e08901cd4
16	20.500.12156.1/2773	2	\N	c82a1191-3a63-4667-bfda-6080261a4069
17	20.500.12156.1/2024	2	\N	2a63b298-96d5-4ded-a0fc-e7ca3bcff831
18	20.500.12156.1/2245	2	\N	23356d3d-62c2-49f3-a1cd-e51531698402
19	20.500.12156.1/2586	2	\N	6a7ea32d-9b1f-46c2-a002-75292eef9a8f
20	20.500.12156.1/2139	2	\N	e34bee2e-ff66-4fda-8ef0-a70a9cc27139
21	20.500.12156.1/2555	2	\N	5cc3c183-a750-4b2a-8d8d-d4e4fdcc31d7
22	20.500.12156.1/4755	2	\N	987f4af4-d57e-4f67-b3d3-0513b13bf9f2
23	20.500.12156.1/1876	2	\N	b0e86f74-1ff4-495d-827b-0d8b4f1c9d4b
24	20.500.12156.1/2777	2	\N	68370f47-347b-40f5-a0bd-4cc2c6119c8e
25	20.500.12156.1/2443	2	\N	65396002-d1d3-4237-83ee-52d2dc506bd5
26	20.500.12156.1/3183	2	\N	5affab90-9b3a-4a32-aea4-15fbf5edaf17
27	20.500.12156.1/4655	2	\N	7d0a10d2-1ace-4694-b908-79630b8e0b78
28	20.500.12156.1/2059	2	\N	adad82ef-4c7d-4b61-b07a-4684c037320e
29	20.500.12156.1/4663	2	\N	2f3cc1e7-2490-427e-b00f-241dcab457a2
30	20.500.12156.1/2152	2	\N	09ec0ef8-ac24-4a29-a340-261df0304de8
31	20.500.12156.1/2602	2	\N	d6994539-a007-4084-a892-2620add43f25
32	20.500.12156.1/4796	2	\N	d3ed1b45-421a-47cf-b7a3-333df5f5599e
33	20.500.12156.1/3925	2	\N	51b13546-800a-44d8-81a1-f84086a43b9c
34	20.500.12156.1/6243	2	\N	4fc27f14-159f-46ec-90fe-9dfacfbd3632
35	20.500.12156.1/2737	2	\N	2ff5657d-1e3c-46f3-b842-37c0c6ee32e1
36	20.500.12156.1/2754	2	\N	02e74364-56c7-4094-83cd-164c8db70bfb
37	20.500.12156.1/6391	2	\N	e729bb52-e369-4170-a38c-a011feddaedb
38	20.500.12156.1/2305	2	\N	b49f6ec8-5476-4b8c-8eab-63f99a7d46b2
39	20.500.12156.1/4724	2	\N	97b1eb6d-cf2f-41bb-8943-bb70f042485a
40	20.500.12156.1/4677	2	\N	c0b68a77-7569-45c4-a10b-2d3fca4fed29
41	20.500.12156.1/2419	2	\N	6ef6ce81-f0f0-4345-8faa-081139d4e475
42	20.500.12156.1/2267	2	\N	16c0c95b-6b04-4f57-9c5c-03c975d4daf4
\.


--
-- Name: handle_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.handle_id_seq', 42, true);


--
-- Name: handle_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.handle_seq', 2, true);


--
-- Data for Name: harvested_collection; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.harvested_collection (harvest_type, oai_source, oai_set_id, harvest_message, metadata_config_id, harvest_status, harvest_start_time, last_harvested, id, collection_id) FROM stdin;
\.


--
-- Name: harvested_collection_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.harvested_collection_seq', 1, false);


--
-- Data for Name: harvested_item; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.harvested_item (last_harvested, oai_id, id, item_id) FROM stdin;
\.


--
-- Name: harvested_item_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.harvested_item_seq', 1, false);


--
-- Name: history_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.history_seq', 1, false);


--
-- Data for Name: item; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.item (item_id, in_archive, withdrawn, last_modified, discoverable, uuid, submitter_id, owning_collection) FROM stdin;
\N	t	f	2019-07-19 08:43:26.649-05	t	d6be9004-bec3-4705-9a4e-f22796cd979e	41a39b48-a9ef-41c6-8aaf-98870d995b04	608a1f61-7aa3-4e18-9ff9-ef7a767412c4
\N	t	f	2019-07-19 08:43:28.05-05	t	1647a00d-03d4-484f-9747-7f10f7eb2088	41a39b48-a9ef-41c6-8aaf-98870d995b04	608a1f61-7aa3-4e18-9ff9-ef7a767412c4
\N	t	f	2019-07-19 08:43:28.665-05	t	6042b9c6-0f1a-4714-863e-0208d96df43a	41a39b48-a9ef-41c6-8aaf-98870d995b04	608a1f61-7aa3-4e18-9ff9-ef7a767412c4
\N	t	f	2019-07-19 08:43:30.065-05	t	4e20305a-a171-4533-bb0d-0fde80140a82	41a39b48-a9ef-41c6-8aaf-98870d995b04	608a1f61-7aa3-4e18-9ff9-ef7a767412c4
\N	t	f	2019-07-19 08:43:31.289-05	t	f0ea3089-84e1-4a9a-9817-16d15100fb54	41a39b48-a9ef-41c6-8aaf-98870d995b04	608a1f61-7aa3-4e18-9ff9-ef7a767412c4
\N	t	f	2019-07-19 08:43:33.522-05	t	edbc5bff-4b36-4b31-b08b-ef5b67d01a74	41a39b48-a9ef-41c6-8aaf-98870d995b04	608a1f61-7aa3-4e18-9ff9-ef7a767412c4
\N	t	f	2019-07-19 08:43:35.464-05	t	f5487302-92d0-4914-89f6-2190c49f4ced	41a39b48-a9ef-41c6-8aaf-98870d995b04	608a1f61-7aa3-4e18-9ff9-ef7a767412c4
\N	t	f	2019-07-19 08:43:37.311-05	t	b8684970-4418-4f5b-a99a-c46ed5721710	41a39b48-a9ef-41c6-8aaf-98870d995b04	608a1f61-7aa3-4e18-9ff9-ef7a767412c4
\N	t	f	2019-07-19 08:43:38.608-05	t	f0c85891-e655-4e8e-a6ba-eabba6fdfc97	41a39b48-a9ef-41c6-8aaf-98870d995b04	608a1f61-7aa3-4e18-9ff9-ef7a767412c4
\N	t	f	2019-07-19 08:43:39.339-05	t	af4b4244-1e85-4b33-9ca0-c267b1130df0	41a39b48-a9ef-41c6-8aaf-98870d995b04	608a1f61-7aa3-4e18-9ff9-ef7a767412c4
\N	t	f	2019-07-19 08:43:43.713-05	t	b17e6dc6-cd53-4646-b790-06d1a12ee1ab	41a39b48-a9ef-41c6-8aaf-98870d995b04	608a1f61-7aa3-4e18-9ff9-ef7a767412c4
\N	t	f	2019-07-19 08:43:45.281-05	t	3b3166f9-bb45-486b-bb08-6e2e08901cd4	41a39b48-a9ef-41c6-8aaf-98870d995b04	608a1f61-7aa3-4e18-9ff9-ef7a767412c4
\N	t	f	2019-07-19 08:43:47.291-05	t	c82a1191-3a63-4667-bfda-6080261a4069	41a39b48-a9ef-41c6-8aaf-98870d995b04	608a1f61-7aa3-4e18-9ff9-ef7a767412c4
\N	t	f	2019-07-19 08:43:48.135-05	t	2a63b298-96d5-4ded-a0fc-e7ca3bcff831	41a39b48-a9ef-41c6-8aaf-98870d995b04	608a1f61-7aa3-4e18-9ff9-ef7a767412c4
\N	t	f	2019-07-19 08:43:49.136-05	t	23356d3d-62c2-49f3-a1cd-e51531698402	41a39b48-a9ef-41c6-8aaf-98870d995b04	608a1f61-7aa3-4e18-9ff9-ef7a767412c4
\N	t	f	2019-07-19 08:43:50.149-05	t	6a7ea32d-9b1f-46c2-a002-75292eef9a8f	41a39b48-a9ef-41c6-8aaf-98870d995b04	608a1f61-7aa3-4e18-9ff9-ef7a767412c4
\N	t	f	2019-07-19 08:43:51.401-05	t	e34bee2e-ff66-4fda-8ef0-a70a9cc27139	41a39b48-a9ef-41c6-8aaf-98870d995b04	608a1f61-7aa3-4e18-9ff9-ef7a767412c4
\N	t	f	2019-07-19 08:43:52.507-05	t	5cc3c183-a750-4b2a-8d8d-d4e4fdcc31d7	41a39b48-a9ef-41c6-8aaf-98870d995b04	608a1f61-7aa3-4e18-9ff9-ef7a767412c4
\N	t	f	2019-07-19 08:43:53.835-05	t	987f4af4-d57e-4f67-b3d3-0513b13bf9f2	41a39b48-a9ef-41c6-8aaf-98870d995b04	608a1f61-7aa3-4e18-9ff9-ef7a767412c4
\N	t	f	2019-07-19 08:43:55.656-05	t	b0e86f74-1ff4-495d-827b-0d8b4f1c9d4b	41a39b48-a9ef-41c6-8aaf-98870d995b04	608a1f61-7aa3-4e18-9ff9-ef7a767412c4
\N	t	f	2019-07-19 08:43:58.281-05	t	68370f47-347b-40f5-a0bd-4cc2c6119c8e	41a39b48-a9ef-41c6-8aaf-98870d995b04	608a1f61-7aa3-4e18-9ff9-ef7a767412c4
\N	t	f	2019-07-19 08:43:59.578-05	t	65396002-d1d3-4237-83ee-52d2dc506bd5	41a39b48-a9ef-41c6-8aaf-98870d995b04	608a1f61-7aa3-4e18-9ff9-ef7a767412c4
\N	t	f	2019-07-19 08:44:01.738-05	t	5affab90-9b3a-4a32-aea4-15fbf5edaf17	41a39b48-a9ef-41c6-8aaf-98870d995b04	608a1f61-7aa3-4e18-9ff9-ef7a767412c4
\N	t	f	2019-07-19 08:44:02.885-05	t	7d0a10d2-1ace-4694-b908-79630b8e0b78	41a39b48-a9ef-41c6-8aaf-98870d995b04	608a1f61-7aa3-4e18-9ff9-ef7a767412c4
\N	t	f	2019-07-19 08:44:06.324-05	t	adad82ef-4c7d-4b61-b07a-4684c037320e	41a39b48-a9ef-41c6-8aaf-98870d995b04	608a1f61-7aa3-4e18-9ff9-ef7a767412c4
\N	t	f	2019-07-19 08:44:07.762-05	t	2f3cc1e7-2490-427e-b00f-241dcab457a2	41a39b48-a9ef-41c6-8aaf-98870d995b04	608a1f61-7aa3-4e18-9ff9-ef7a767412c4
\N	t	f	2019-07-19 08:44:08.971-05	t	09ec0ef8-ac24-4a29-a340-261df0304de8	41a39b48-a9ef-41c6-8aaf-98870d995b04	608a1f61-7aa3-4e18-9ff9-ef7a767412c4
\N	t	f	2019-07-19 08:44:11.547-05	t	d6994539-a007-4084-a892-2620add43f25	41a39b48-a9ef-41c6-8aaf-98870d995b04	608a1f61-7aa3-4e18-9ff9-ef7a767412c4
\N	t	f	2019-07-19 08:44:13.141-05	t	d3ed1b45-421a-47cf-b7a3-333df5f5599e	41a39b48-a9ef-41c6-8aaf-98870d995b04	608a1f61-7aa3-4e18-9ff9-ef7a767412c4
\N	t	f	2019-07-19 08:44:14.196-05	t	51b13546-800a-44d8-81a1-f84086a43b9c	41a39b48-a9ef-41c6-8aaf-98870d995b04	608a1f61-7aa3-4e18-9ff9-ef7a767412c4
\N	t	f	2019-07-19 08:44:15.486-05	t	4fc27f14-159f-46ec-90fe-9dfacfbd3632	41a39b48-a9ef-41c6-8aaf-98870d995b04	608a1f61-7aa3-4e18-9ff9-ef7a767412c4
\N	t	f	2019-07-19 08:44:23.554-05	t	2ff5657d-1e3c-46f3-b842-37c0c6ee32e1	41a39b48-a9ef-41c6-8aaf-98870d995b04	608a1f61-7aa3-4e18-9ff9-ef7a767412c4
\N	t	f	2019-07-19 08:44:25.968-05	t	02e74364-56c7-4094-83cd-164c8db70bfb	41a39b48-a9ef-41c6-8aaf-98870d995b04	608a1f61-7aa3-4e18-9ff9-ef7a767412c4
\N	t	f	2019-07-19 08:44:26.999-05	t	e729bb52-e369-4170-a38c-a011feddaedb	41a39b48-a9ef-41c6-8aaf-98870d995b04	608a1f61-7aa3-4e18-9ff9-ef7a767412c4
\N	t	f	2019-07-19 08:44:28.143-05	t	b49f6ec8-5476-4b8c-8eab-63f99a7d46b2	41a39b48-a9ef-41c6-8aaf-98870d995b04	608a1f61-7aa3-4e18-9ff9-ef7a767412c4
\N	t	f	2019-07-19 08:44:29.499-05	t	97b1eb6d-cf2f-41bb-8943-bb70f042485a	41a39b48-a9ef-41c6-8aaf-98870d995b04	608a1f61-7aa3-4e18-9ff9-ef7a767412c4
\N	t	f	2019-07-19 08:44:30.587-05	t	c0b68a77-7569-45c4-a10b-2d3fca4fed29	41a39b48-a9ef-41c6-8aaf-98870d995b04	608a1f61-7aa3-4e18-9ff9-ef7a767412c4
\N	t	f	2019-07-19 08:44:31.383-05	t	6ef6ce81-f0f0-4345-8faa-081139d4e475	41a39b48-a9ef-41c6-8aaf-98870d995b04	608a1f61-7aa3-4e18-9ff9-ef7a767412c4
\N	t	f	2019-07-19 08:44:32.726-05	t	16c0c95b-6b04-4f57-9c5c-03c975d4daf4	41a39b48-a9ef-41c6-8aaf-98870d995b04	608a1f61-7aa3-4e18-9ff9-ef7a767412c4
\.


--
-- Data for Name: item2bundle; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.item2bundle (bundle_id, item_id) FROM stdin;
ff09241d-855a-49c2-8fbc-45502c8b8af3	d6be9004-bec3-4705-9a4e-f22796cd979e
9ab336a9-ac0f-4cbd-9b75-d7a9688ce99a	d6be9004-bec3-4705-9a4e-f22796cd979e
a80c401c-0c0e-4822-b740-af9c3abfdf0d	1647a00d-03d4-484f-9747-7f10f7eb2088
0b8918a1-7938-4a16-adad-47cc659081a8	1647a00d-03d4-484f-9747-7f10f7eb2088
3b7d13a5-363f-47d1-8cd9-62916736446a	6042b9c6-0f1a-4714-863e-0208d96df43a
df393130-4c6e-4939-aa32-06db82f60c5e	6042b9c6-0f1a-4714-863e-0208d96df43a
49c37abb-eb40-4511-bfa4-85b47f4f9078	4e20305a-a171-4533-bb0d-0fde80140a82
3f33561d-885f-4ada-bb9e-40909ce55a83	4e20305a-a171-4533-bb0d-0fde80140a82
105ac278-02a6-41d7-aa6b-4e0573bf2ee7	f0ea3089-84e1-4a9a-9817-16d15100fb54
120ef5da-fc4e-4952-b8a8-4ffd42fc6fe9	f0ea3089-84e1-4a9a-9817-16d15100fb54
5a9aa0c7-bca9-4b61-acf6-087fd97eb722	edbc5bff-4b36-4b31-b08b-ef5b67d01a74
b77baa82-dccc-436e-b001-15055196e25e	edbc5bff-4b36-4b31-b08b-ef5b67d01a74
4d9f173b-7552-4326-ac76-a0950e387ec8	f5487302-92d0-4914-89f6-2190c49f4ced
e6dd77b8-988c-415e-83c4-9e6003c237a7	f5487302-92d0-4914-89f6-2190c49f4ced
8ba24c03-9683-4bd5-8182-63a1188df55e	b8684970-4418-4f5b-a99a-c46ed5721710
9ba1ff9a-0530-4abb-aade-a84ee2415616	b8684970-4418-4f5b-a99a-c46ed5721710
70fdd62c-343b-4d75-b628-2040c97479e8	f0c85891-e655-4e8e-a6ba-eabba6fdfc97
86832dac-4fbe-42d9-8a8d-94a9ce22cf20	f0c85891-e655-4e8e-a6ba-eabba6fdfc97
042e5ec3-7be3-4a30-9009-e6d3839bfda7	af4b4244-1e85-4b33-9ca0-c267b1130df0
9ea9f933-ee16-4dbd-889d-fdced9321c03	af4b4244-1e85-4b33-9ca0-c267b1130df0
4cf5e155-be37-4290-93fe-22e3edf55167	b17e6dc6-cd53-4646-b790-06d1a12ee1ab
0ced5b26-bdcf-47af-96ba-588ad0784150	b17e6dc6-cd53-4646-b790-06d1a12ee1ab
611b0593-f0d8-4a0c-b694-d3143e35a3c8	3b3166f9-bb45-486b-bb08-6e2e08901cd4
17130f2d-bc9c-412d-9e9b-6f17d2deaaef	3b3166f9-bb45-486b-bb08-6e2e08901cd4
7423f872-ff3a-417c-b5fd-0ab44a56d884	c82a1191-3a63-4667-bfda-6080261a4069
4e2f8ce5-121d-4f09-b736-953c01ffab7c	c82a1191-3a63-4667-bfda-6080261a4069
a8361706-0b42-4805-8f75-911f1b73b298	2a63b298-96d5-4ded-a0fc-e7ca3bcff831
516667ff-c91e-40f5-95b5-c0905f6d9681	2a63b298-96d5-4ded-a0fc-e7ca3bcff831
9b4bc286-450d-4ddf-aa38-90b226234686	23356d3d-62c2-49f3-a1cd-e51531698402
e2c4c22c-eb00-425a-9cc1-b9240fd18311	23356d3d-62c2-49f3-a1cd-e51531698402
65710ee6-0ba1-41d7-baf4-d488222918a7	6a7ea32d-9b1f-46c2-a002-75292eef9a8f
3a6f9fd1-ada9-4a1f-a5b9-f4ee408c36d0	6a7ea32d-9b1f-46c2-a002-75292eef9a8f
437a093f-a0eb-4947-9366-12e7cea4f579	e34bee2e-ff66-4fda-8ef0-a70a9cc27139
f5322472-6bb0-4db5-b7c6-ff39f0f389bf	e34bee2e-ff66-4fda-8ef0-a70a9cc27139
06fbd362-9e07-4867-977b-1971ef7e1812	5cc3c183-a750-4b2a-8d8d-d4e4fdcc31d7
a2621d19-9ee1-4e91-b431-9c56ff0a9a95	5cc3c183-a750-4b2a-8d8d-d4e4fdcc31d7
06956b32-551b-4839-8298-46656be0928e	987f4af4-d57e-4f67-b3d3-0513b13bf9f2
317d384a-8bd7-443f-ae59-9b110bd89412	987f4af4-d57e-4f67-b3d3-0513b13bf9f2
f9cb7f87-a781-4b0f-8a9a-7eb5bc501b65	b0e86f74-1ff4-495d-827b-0d8b4f1c9d4b
435a868d-93c3-41ec-b2d4-8ba1ff771e1f	b0e86f74-1ff4-495d-827b-0d8b4f1c9d4b
8d8ceac0-5b32-45c2-a928-32ebf9070558	68370f47-347b-40f5-a0bd-4cc2c6119c8e
0fd73a3a-ff0d-429c-a24e-4bc9443a54b4	68370f47-347b-40f5-a0bd-4cc2c6119c8e
78e9be50-f651-4538-8319-a6e2ca4c2d91	65396002-d1d3-4237-83ee-52d2dc506bd5
0bb280a7-63a0-459f-8e4b-c5473e9337ab	65396002-d1d3-4237-83ee-52d2dc506bd5
ef47138a-4950-44d5-a967-2247a54bd4ed	5affab90-9b3a-4a32-aea4-15fbf5edaf17
22de0971-5c94-408a-b79a-784e7cca0856	5affab90-9b3a-4a32-aea4-15fbf5edaf17
d5e54765-b028-4723-939d-670ae49d1292	7d0a10d2-1ace-4694-b908-79630b8e0b78
a52a46a0-92c0-43f8-9387-bbad149a9a4e	7d0a10d2-1ace-4694-b908-79630b8e0b78
88d5b1c1-f0d7-49c6-adbb-36e87c268f46	adad82ef-4c7d-4b61-b07a-4684c037320e
4b3a9584-97fb-4718-9534-f5028a1b99b8	adad82ef-4c7d-4b61-b07a-4684c037320e
61b28a3c-d6b7-4bc7-b304-570a3d6ec4fb	2f3cc1e7-2490-427e-b00f-241dcab457a2
ffebcf7e-61b5-4acd-9cec-7919f7a1580a	2f3cc1e7-2490-427e-b00f-241dcab457a2
85b21ccf-7fe9-4a85-99b8-3f14defd9024	09ec0ef8-ac24-4a29-a340-261df0304de8
a40bcc91-5bff-4767-a812-ec14e1da96b0	09ec0ef8-ac24-4a29-a340-261df0304de8
8431ac09-4f3a-43c3-aa3d-1138d3e7fd28	d6994539-a007-4084-a892-2620add43f25
d1e98419-e25f-4d72-a6e3-5c38a98fbc72	d6994539-a007-4084-a892-2620add43f25
9a62e23b-0d7c-47c5-9882-82055f97d477	d3ed1b45-421a-47cf-b7a3-333df5f5599e
8fb920ce-a656-49ff-a9b5-29f04ace2df9	d3ed1b45-421a-47cf-b7a3-333df5f5599e
d5cdecba-6e76-4615-972e-fb7166735f0a	51b13546-800a-44d8-81a1-f84086a43b9c
0c1c8c49-87ee-4053-b1b8-078b031a4870	51b13546-800a-44d8-81a1-f84086a43b9c
408036eb-460c-44f3-823c-0f4f21b5e7d8	4fc27f14-159f-46ec-90fe-9dfacfbd3632
42f9fb24-ef94-4d14-b9ce-c7fb2bb12c13	4fc27f14-159f-46ec-90fe-9dfacfbd3632
95248b9d-2a11-4f62-a952-f4ef8ecf6142	2ff5657d-1e3c-46f3-b842-37c0c6ee32e1
eb9ff9c5-5d9d-4de5-a5ea-0fc5f40e2594	2ff5657d-1e3c-46f3-b842-37c0c6ee32e1
f0be2af3-8f78-4b7e-908e-da13b7c8f998	02e74364-56c7-4094-83cd-164c8db70bfb
1640fc10-07f2-4ac9-ad35-5ca970d7e3dc	02e74364-56c7-4094-83cd-164c8db70bfb
9817e8d8-8eee-42b4-a188-b360ee9d1f3c	e729bb52-e369-4170-a38c-a011feddaedb
7a1434b7-6895-4f14-a80b-c2b1205bac55	e729bb52-e369-4170-a38c-a011feddaedb
a8fad082-f1f4-49f9-a73d-7df879ca8df3	b49f6ec8-5476-4b8c-8eab-63f99a7d46b2
ea1a91b4-37c3-4606-9f2a-bbe2e77dd621	b49f6ec8-5476-4b8c-8eab-63f99a7d46b2
cdb86a05-b0b4-497f-8808-534d330ef40f	97b1eb6d-cf2f-41bb-8943-bb70f042485a
7f71e243-6c60-4665-8f1e-cd04ea138d94	97b1eb6d-cf2f-41bb-8943-bb70f042485a
a7a81151-eac6-41ca-ac57-07c5f3e32100	c0b68a77-7569-45c4-a10b-2d3fca4fed29
18fd7b92-a579-4299-97ca-00c53e30065f	c0b68a77-7569-45c4-a10b-2d3fca4fed29
58114c56-4af2-4df8-9ccf-11f62861190d	6ef6ce81-f0f0-4345-8faa-081139d4e475
b0af88a3-1267-44fa-a33e-e69f6652c53f	6ef6ce81-f0f0-4345-8faa-081139d4e475
2cd4b643-8b70-4e10-9ae9-6ac90e6e82ac	16c0c95b-6b04-4f57-9c5c-03c975d4daf4
db4868a4-e0d0-4d14-9f0b-aa32d6b0e8cf	16c0c95b-6b04-4f57-9c5c-03c975d4daf4
\.


--
-- Data for Name: metadatafieldregistry; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.metadatafieldregistry (metadata_field_id, metadata_schema_id, element, qualifier, scope_note) FROM stdin;
1	2	firstname	\N	\N
2	2	lastname	\N	\N
3	2	phone	\N	\N
4	2	language	\N	\N
5	1	provenance	\N	\N
6	1	rights	license	\N
7	1	contributor	\N	A person, organization, or service responsible for the content of the resource.  Catch-all for unspecified contributors.
8	1	contributor	advisor	Use primarily for thesis advisor.
9	1	contributor	author	\N
10	1	contributor	editor	\N
11	1	contributor	illustrator	\N
12	1	contributor	other	\N
13	1	coverage	spatial	Spatial characteristics of content.
14	1	coverage	temporal	Temporal characteristics of content.
15	1	creator	\N	Do not use; only for harvested metadata.
16	1	date	\N	Use qualified form if possible.
17	1	date	accessioned	Date DSpace takes possession of item.
18	1	date	available	Date or date range item became available to the public.
19	1	date	copyright	Date of copyright.
20	1	date	created	Date of creation or manufacture of intellectual content if different from date.issued.
21	1	date	issued	Date of publication or distribution.
22	1	date	submitted	Recommend for theses/dissertations.
23	1	identifier	\N	Catch-all for unambiguous identifiers not defined by\n    qualified form; use identifier.other for a known identifier common\n    to a local collection instead of unqualified form.
24	1	identifier	citation	Human-readable, standard bibliographic citation \n    of non-DSpace format of this item
25	1	identifier	govdoc	A government document number
26	1	identifier	isbn	International Standard Book Number
27	1	identifier	issn	International Standard Serial Number
28	1	identifier	sici	Serial Item and Contribution Identifier
29	1	identifier	ismn	International Standard Music Number
30	1	identifier	other	A known identifier type common to a local collection.
31	1	identifier	uri	Uniform Resource Identifier
32	1	description	\N	Catch-all for any description not defined by qualifiers.
33	1	description	abstract	Abstract or summary.
34	1	description	provenance	The history of custody of the item since its creation, including any changes successive custodians made to it.
35	1	description	sponsorship	Information about sponsoring agencies, individuals, or\n    contractual arrangements for the item.
36	1	description	statementofresponsibility	To preserve statement of responsibility from MARC records.
37	1	description	tableofcontents	A table of contents for a given item.
38	1	description	uri	Uniform Resource Identifier pointing to description of\n    this item.
39	1	format	\N	Catch-all for any format information not defined by qualifiers.
40	1	format	extent	Size or duration.
41	1	format	medium	Physical medium.
42	1	format	mimetype	Registered MIME type identifiers.
43	1	language	\N	Catch-all for non-ISO forms of the language of the\n    item, accommodating harvested values.
44	1	language	iso	Current ISO standard for language of intellectual content, including country codes (e.g. "en_US").
45	1	publisher	\N	Entity responsible for publication, distribution, or imprint.
46	1	relation	\N	Catch-all for references to other related items.
47	1	relation	isformatof	References additional physical form.
48	1	relation	ispartof	References physically or logically containing item.
49	1	relation	ispartofseries	Series name and number within that series, if available.
50	1	relation	haspart	References physically or logically contained item.
51	1	relation	isversionof	References earlier version.
52	1	relation	hasversion	References later version.
53	1	relation	isbasedon	References source.
54	1	relation	isreferencedby	Pointed to by referenced resource.
55	1	relation	requires	Referenced resource is required to support function,\n    delivery, or coherence of item.
56	1	relation	replaces	References preceeding item.
57	1	relation	isreplacedby	References succeeding item.
58	1	relation	uri	References Uniform Resource Identifier for related item.
59	1	rights	\N	Terms governing use and reproduction.
60	1	rights	uri	References terms governing use and reproduction.
61	1	source	\N	Do not use; only for harvested metadata.
62	1	source	uri	Do not use; only for harvested metadata.
63	1	subject	\N	Uncontrolled index term.
64	1	subject	classification	Catch-all for value from local classification system;\n    global classification systems will receive specific qualifier
65	1	subject	ddc	Dewey Decimal Classification Number
66	1	subject	lcc	Library of Congress Classification Number
67	1	subject	lcsh	Library of Congress Subject Headings
68	1	subject	mesh	MEdical Subject Headings
69	1	subject	other	Local controlled vocabulary; global vocabularies will receive specific qualifier.
70	1	title	\N	Title statement/title proper.
71	1	title	alternative	Varying (or substitute) form of title proper appearing in item,\n    e.g. abbreviation or translation
72	1	type	\N	Nature or genre of content.
73	3	abstract	\N	A summary of the resource.
74	3	accessRights	\N	Information about who can access the resource or an indication of its security status. May include information regarding access or restrictions based on privacy, security, or other policies.
75	3	accrualMethod	\N	The method by which items are added to a collection.
76	3	accrualPeriodicity	\N	The frequency with which items are added to a collection.
77	3	accrualPolicy	\N	The policy governing the addition of items to a collection.
78	3	alternative	\N	An alternative name for the resource.
79	3	audience	\N	A class of entity for whom the resource is intended or useful.
80	3	available	\N	Date (often a range) that the resource became or will become available.
81	3	bibliographicCitation	\N	Recommended practice is to include sufficient bibliographic detail to identify the resource as unambiguously as possible.
82	3	conformsTo	\N	An established standard to which the described resource conforms.
83	3	contributor	\N	An entity responsible for making contributions to the resource. Examples of a Contributor include a person, an organization, or a service.
84	3	coverage	\N	The spatial or temporal topic of the resource, the spatial applicability of the resource, or the jurisdiction under which the resource is relevant.
85	3	created	\N	Date of creation of the resource.
86	3	creator	\N	An entity primarily responsible for making the resource.
87	3	date	\N	A point or period of time associated with an event in the lifecycle of the resource.
88	3	dateAccepted	\N	Date of acceptance of the resource.
89	3	dateCopyrighted	\N	Date of copyright.
90	3	dateSubmitted	\N	Date of submission of the resource.
91	3	description	\N	An account of the resource.
92	3	educationLevel	\N	A class of entity, defined in terms of progression through an educational or training context, for which the described resource is intended.
93	3	extent	\N	The size or duration of the resource.
94	3	format	\N	The file format, physical medium, or dimensions of the resource.
95	3	hasFormat	\N	A related resource that is substantially the same as the pre-existing described resource, but in another format.
96	3	hasPart	\N	A related resource that is included either physically or logically in the described resource.
97	3	hasVersion	\N	A related resource that is a version, edition, or adaptation of the described resource.
98	3	identifier	\N	An unambiguous reference to the resource within a given context.
99	3	instructionalMethod	\N	A process, used to engender knowledge, attitudes and skills, that the described resource is designed to support.
100	3	isFormatOf	\N	A related resource that is substantially the same as the described resource, but in another format.
101	3	isPartOf	\N	A related resource in which the described resource is physically or logically included.
102	3	isReferencedBy	\N	A related resource that references, cites, or otherwise points to the described resource.
103	3	isReplacedBy	\N	A related resource that supplants, displaces, or supersedes the described resource.
104	3	isRequiredBy	\N	A related resource that requires the described resource to support its function, delivery, or coherence.
105	3	issued	\N	Date of formal issuance (e.g., publication) of the resource.
106	3	isVersionOf	\N	A related resource of which the described resource is a version, edition, or adaptation.
107	3	language	\N	A language of the resource.
108	3	license	\N	A legal document giving official permission to do something with the resource.
109	3	mediator	\N	An entity that mediates access to the resource and for whom the resource is intended or useful.
110	3	medium	\N	The material or physical carrier of the resource.
111	3	modified	\N	Date on which the resource was changed.
112	3	provenance	\N	A statement of any changes in ownership and custody of the resource since its creation that are significant for its authenticity, integrity, and interpretation.
113	3	publisher	\N	An entity responsible for making the resource available.
114	3	references	\N	A related resource that is referenced, cited, or otherwise pointed to by the described resource.
115	3	relation	\N	A related resource.
116	3	replaces	\N	A related resource that is supplanted, displaced, or superseded by the described resource.
117	3	requires	\N	A related resource that is required by the described resource to support its function, delivery, or coherence.
118	3	rights	\N	Information about rights held in and over the resource.
119	3	rightsHolder	\N	A person or organization owning or managing rights over the resource.
120	3	source	\N	A related resource from which the described resource is derived.
121	3	spatial	\N	Spatial characteristics of the resource.
122	3	subject	\N	The topic of the resource.
123	3	tableOfContents	\N	A list of subunits of the resource.
124	3	temporal	\N	Temporal characteristics of the resource.
125	3	title	\N	A name given to the resource.
126	3	type	\N	The nature or genre of the resource.
127	3	valid	\N	Date (often a range) of validity of a resource.
128	1	date	updated	The last time the item was updated via the SWORD interface
129	1	description	version	The Peer Reviewed status of an item
130	1	identifier	slug	a uri supplied via the sword slug header, as a suggested uri for the item
131	1	language	rfc3066	the rfc3066 form of the language for the item
132	1	rights	holder	The owner of the copyright
134	1	coverage	point	Identifies a geographic point by latitude and longitude.
133	1	coverage	\N	added field
\.


--
-- Name: metadatafieldregistry_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.metadatafieldregistry_seq', 134, true);


--
-- Data for Name: metadataschemaregistry; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.metadataschemaregistry (metadata_schema_id, namespace, short_id) FROM stdin;
1	http://dublincore.org/documents/dcmi-terms/	dc
2	http://dspace.org/eperson	eperson
3	http://purl.org/dc/terms/	dcterms
4	http://dspace.org/namespace/local/	local
\.


--
-- Name: metadataschemaregistry_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.metadataschemaregistry_seq', 4, true);


--
-- Data for Name: metadatavalue; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.metadatavalue (metadata_value_id, metadata_field_id, text_value, text_lang, place, authority, confidence, dspace_object_id) FROM stdin;
1	2	Jin	\N	0	\N	-1	41a39b48-a9ef-41c6-8aaf-98870d995b04
2	1	Ying	\N	0	\N	-1	41a39b48-a9ef-41c6-8aaf-98870d995b04
3	4	en	\N	0	\N	-1	41a39b48-a9ef-41c6-8aaf-98870d995b04
4	70	ImagineRio	\N	0	\N	-1	6bbf5702-dd70-4e11-9ae9-bb1800b8f917
5	70	ImagineRio	\N	0	\N	-1	608a1f61-7aa3-4e18-9ff9-ef7a767412c4
1343	70	002080BR0205.jpg.jpg	\N	0	\N	-1	17d71f15-eaf1-41da-85c3-a1ac3129ea60
1344	61	Written by FormatFilter org.dspace.app.mediafilter.JPEGFilter on 2019-07-19T13:43:26Z (GMT).	\N	0	\N	-1	17d71f15-eaf1-41da-85c3-a1ac3129ea60
1345	32	Generated Thumbnail	\N	0	\N	-1	17d71f15-eaf1-41da-85c3-a1ac3129ea60
32	32	4,5 x 11 cm	pt_BR	1	\N	-1	d6be9004-bec3-4705-9a4e-f22796cd979e
1346	70	007A5P4F1-07.jpg.jpg	\N	0	\N	-1	d145f27a-a203-4663-915f-7d5718fbc387
1347	61	Written by FormatFilter org.dspace.app.mediafilter.JPEGFilter on 2019-07-19T13:43:28Z (GMT).	\N	0	\N	-1	d145f27a-a203-4663-915f-7d5718fbc387
36	59	Solicitar imagem junto ao detentor dos direitos indicado no Copyright	pt_BR	1	\N	-1	d6be9004-bec3-4705-9a4e-f22796cd979e
1348	32	Generated Thumbnail	\N	0	\N	-1	d145f27a-a203-4663-915f-7d5718fbc387
39	63	GUILHERME SANTOS	pt_BR	1	\N	-1	d6be9004-bec3-4705-9a4e-f22796cd979e
1349	70	002055RevdaArmada023.jpg.jpg	\N	0	\N	-1	46b7d0d6-e7be-499d-ae60-ec10bc7301f2
1350	61	Written by FormatFilter org.dspace.app.mediafilter.JPEGFilter on 2019-07-19T13:43:28Z (GMT).	\N	0	\N	-1	46b7d0d6-e7be-499d-ae60-ec10bc7301f2
1351	32	Generated Thumbnail	\N	0	\N	-1	46b7d0d6-e7be-499d-ae60-ec10bc7301f2
45	133	RJ	pt_BR	1	\N	-1	d6be9004-bec3-4705-9a4e-f22796cd979e
47	70	ORIGINAL	\N	1	\N	-1	ff09241d-855a-49c2-8fbc-45502c8b8af3
25	7	Santos, Guilherme	pt_BR	0	\N	-1	d6be9004-bec3-4705-9a4e-f22796cd979e
26	16	1926	pt_BR	0	\N	-1	d6be9004-bec3-4705-9a4e-f22796cd979e
27	17	2015-04-16T12:51:07Z		0	\N	-1	d6be9004-bec3-4705-9a4e-f22796cd979e
28	18	2015-04-16T12:51:07Z		0	\N	-1	d6be9004-bec3-4705-9a4e-f22796cd979e
29	23	002080BR0205.jpg	pt_BR	0	\N	-1	d6be9004-bec3-4705-9a4e-f22796cd979e
31	32	MONOCROMÁTICA	pt_BR	0	\N	-1	d6be9004-bec3-4705-9a4e-f22796cd979e
33	32	Gelatina/ Prata	pt_BR	2	\N	-1	d6be9004-bec3-4705-9a4e-f22796cd979e
34	34	Made available in DSpace on 2015-04-16T12:51:07Z (GMT). No. of bitstreams: 1\n002080BR0205.jpg: 3577813 bytes, checksum: 06891ce4df41348255bd385adcf85647 (MD5)	en	0	\N	-1	d6be9004-bec3-4705-9a4e-f22796cd979e
35	59	Instituto Moreira Salles	pt_BR	0	\N	-1	d6be9004-bec3-4705-9a4e-f22796cd979e
37	61	Instituto Moreira Salles	pt_BR	0	\N	-1	d6be9004-bec3-4705-9a4e-f22796cd979e
38	63	Transportes	pt_BR	0	\N	-1	d6be9004-bec3-4705-9a4e-f22796cd979e
40	63	Barco	pt_BR	2	\N	-1	d6be9004-bec3-4705-9a4e-f22796cd979e
41	63	Externa	pt_BR	3	\N	-1	d6be9004-bec3-4705-9a4e-f22796cd979e
42	70	Porto de Piedade	pt_BR	0	\N	-1	d6be9004-bec3-4705-9a4e-f22796cd979e
43	72	Diapositivo/ Vidro	pt_BR	0	\N	-1	d6be9004-bec3-4705-9a4e-f22796cd979e
44	133	Rio de Janeiro	pt_BR	0	\N	-1	d6be9004-bec3-4705-9a4e-f22796cd979e
46	133	Brasil	pt_BR	2	\N	-1	d6be9004-bec3-4705-9a4e-f22796cd979e
48	70	002080BR0205.jpg	\N	0	\N	-1	0e574c1b-c9b0-42bc-8ab0-117200a8116a
49	70	THUMBNAIL	\N	1	\N	-1	9ab336a9-ac0f-4cbd-9b75-d7a9688ce99a
50	70	002080BR0205.jpg.jpg	\N	0	\N	-1	abb176ea-5c14-4080-a188-ecadb81b0b76
51	31	https://hdl.handle.net/20.500.12156.1/2058	\N	0	\N	-1	d6be9004-bec3-4705-9a4e-f22796cd979e
52	17	2019-07-19T13:29:27Z	\N	1	\N	-1	d6be9004-bec3-4705-9a4e-f22796cd979e
53	18	2019-07-19T13:29:27Z	\N	1	\N	-1	d6be9004-bec3-4705-9a4e-f22796cd979e
54	34	Made available in DSpace on 2019-07-19T13:29:27Z (GMT). No. of bitstreams: 2\n002080BR0205.jpg: 3577813 bytes, checksum: 06891ce4df41348255bd385adcf85647 (MD5)\n002080BR0205.jpg.jpg: 70543 bytes, checksum: b5274037e55e6586bfe0689d41dfc387 (MD5)	en	1	\N	-1	d6be9004-bec3-4705-9a4e-f22796cd979e
55	32	Generated Thumbnail	\N	0	\N	-1	abb176ea-5c14-4080-a188-ecadb81b0b76
1352	70	007A6P4FP15-10.jpg.jpg	\N	0	\N	-1	608da05e-be8e-4edd-ba48-b952efd151cf
1353	61	Written by FormatFilter org.dspace.app.mediafilter.JPEGFilter on 2019-07-19T13:43:31Z (GMT).	\N	0	\N	-1	608da05e-be8e-4edd-ba48-b952efd151cf
1354	32	Generated Thumbnail	\N	0	\N	-1	608da05e-be8e-4edd-ba48-b952efd151cf
1355	70	007A5P3F03-24.jpg.jpg	\N	0	\N	-1	ed372ab2-cb41-49a5-95ed-3558cdd00a13
1356	61	Written by FormatFilter org.dspace.app.mediafilter.JPEGFilter on 2019-07-19T13:43:38Z (GMT).	\N	0	\N	-1	ed372ab2-cb41-49a5-95ed-3558cdd00a13
1357	32	Generated Thumbnail	\N	0	\N	-1	ed372ab2-cb41-49a5-95ed-3558cdd00a13
1358	70	001LE004002.jpg.jpg	\N	0	\N	-1	9f0fcbd3-5455-484e-9582-d996bbd00a4f
1359	61	Written by FormatFilter org.dspace.app.mediafilter.JPEGFilter on 2019-07-19T13:43:39Z (GMT).	\N	0	\N	-1	9f0fcbd3-5455-484e-9582-d996bbd00a4f
1360	32	Generated Thumbnail	\N	0	\N	-1	9f0fcbd3-5455-484e-9582-d996bbd00a4f
1361	70	002080BR0207.jpg.jpg	\N	0	\N	-1	a0450d8b-5720-4aca-9838-d94a779e68d6
1362	61	Written by FormatFilter org.dspace.app.mediafilter.JPEGFilter on 2019-07-19T13:43:43Z (GMT).	\N	0	\N	-1	a0450d8b-5720-4aca-9838-d94a779e68d6
1363	32	Generated Thumbnail	\N	0	\N	-1	a0450d8b-5720-4aca-9838-d94a779e68d6
1364	70	007_IMG_3381.jpg.jpg	\N	0	\N	-1	089f0a09-8f7b-4504-a99a-a13113cb70d7
1365	61	Written by FormatFilter org.dspace.app.mediafilter.JPEGFilter on 2019-07-19T13:43:45Z (GMT).	\N	0	\N	-1	089f0a09-8f7b-4504-a99a-a13113cb70d7
1366	32	Generated Thumbnail	\N	0	\N	-1	089f0a09-8f7b-4504-a99a-a13113cb70d7
63	32	i:17,0 cm x 22,9 cm      sp: 17,5 cm x 23,4 cm	pt_BR	1	\N	-1	1647a00d-03d4-484f-9747-7f10f7eb2088
1367	70	001LE002002.jpg.jpg	\N	0	\N	-1	14704a8d-e5a9-4374-9ca5-41a0621d600c
67	59	Solicitar imagem junto ao detentor dos direitos indicado no Copyright	pt_BR	1	\N	-1	1647a00d-03d4-484f-9747-7f10f7eb2088
1368	61	Written by FormatFilter org.dspace.app.mediafilter.JPEGFilter on 2019-07-19T13:43:48Z (GMT).	\N	0	\N	-1	14704a8d-e5a9-4374-9ca5-41a0621d600c
1369	32	Generated Thumbnail	\N	0	\N	-1	14704a8d-e5a9-4374-9ca5-41a0621d600c
70	63	Interna	pt_BR	1	\N	-1	1647a00d-03d4-484f-9747-7f10f7eb2088
1370	70	007A5P3F14-13.jpg.jpg	\N	0	\N	-1	16e077ef-74a7-4622-8343-bbd7f22e91d6
1371	61	Written by FormatFilter org.dspace.app.mediafilter.JPEGFilter on 2019-07-19T13:43:49Z (GMT).	\N	0	\N	-1	16e077ef-74a7-4622-8343-bbd7f22e91d6
1372	32	Generated Thumbnail	\N	0	\N	-1	16e077ef-74a7-4622-8343-bbd7f22e91d6
78	133	Morro do Castelo	pt_BR	1	\N	-1	1647a00d-03d4-484f-9747-7f10f7eb2088
81	70	ORIGINAL	\N	1	\N	-1	a80c401c-0c0e-4822-b740-af9c3abfdf0d
56	7	Malta, Augusto	pt_BR	0	\N	-1	1647a00d-03d4-484f-9747-7f10f7eb2088
57	16	1910	pt_BR	0	\N	-1	1647a00d-03d4-484f-9747-7f10f7eb2088
58	17	2015-04-16T12:53:18Z		0	\N	-1	1647a00d-03d4-484f-9747-7f10f7eb2088
59	18	2015-04-16T12:53:18Z		0	\N	-1	1647a00d-03d4-484f-9747-7f10f7eb2088
60	23	007A5P4F1-07.jpg	pt_BR	0	\N	-1	1647a00d-03d4-484f-9747-7f10f7eb2088
1373	70	007NGBMF2430e1824cx98-14.jpg.jpg	\N	0	\N	-1	d91ce649-f50c-4122-8ad8-0c713d5ac137
62	32	P&B	pt_BR	0	\N	-1	1647a00d-03d4-484f-9747-7f10f7eb2088
64	32	Gelatina/ Prata	pt_BR	2	\N	-1	1647a00d-03d4-484f-9747-7f10f7eb2088
65	34	Made available in DSpace on 2015-04-16T12:53:18Z (GMT). No. of bitstreams: 1\n007A5P4F1-07.jpg: 4925771 bytes, checksum: 389e0edd4df7a72475d0fb8df974e494 (MD5)	en	0	\N	-1	1647a00d-03d4-484f-9747-7f10f7eb2088
66	59	Instituto Moreira Salles	pt_BR	0	\N	-1	1647a00d-03d4-484f-9747-7f10f7eb2088
68	61	Gilberto Ferrez	pt_BR	0	\N	-1	1647a00d-03d4-484f-9747-7f10f7eb2088
69	63	Morro do Castelo	pt_BR	0	\N	-1	1647a00d-03d4-484f-9747-7f10f7eb2088
71	63	Arte	pt_BR	2	\N	-1	1647a00d-03d4-484f-9747-7f10f7eb2088
72	63	Arquitetura	pt_BR	3	\N	-1	1647a00d-03d4-484f-9747-7f10f7eb2088
73	63	Horizontal	pt_BR	4	\N	-1	1647a00d-03d4-484f-9747-7f10f7eb2088
74	63	GILBERTO FERREZ	pt_BR	5	\N	-1	1647a00d-03d4-484f-9747-7f10f7eb2088
75	70	Interior da Igreja dos Jesuítas	pt_BR	0	\N	-1	1647a00d-03d4-484f-9747-7f10f7eb2088
76	72	Fotografia/ Papel	pt_BR	0	\N	-1	1647a00d-03d4-484f-9747-7f10f7eb2088
77	133	Rio de Janeiro	pt_BR	0	\N	-1	1647a00d-03d4-484f-9747-7f10f7eb2088
79	133	RJ	pt_BR	2	\N	-1	1647a00d-03d4-484f-9747-7f10f7eb2088
80	133	Brasil	pt_BR	3	\N	-1	1647a00d-03d4-484f-9747-7f10f7eb2088
82	70	007A5P4F1-07.jpg	\N	0	\N	-1	5dc559b8-06ba-45a3-9924-f4edd9d834bf
83	70	THUMBNAIL	\N	1	\N	-1	0b8918a1-7938-4a16-adad-47cc659081a8
84	70	007A5P4F1-07.jpg.jpg	\N	0	\N	-1	adfc389d-5537-472c-9a51-4f1bd18b4888
85	31	https://hdl.handle.net/20.500.12156.1/2413	\N	0	\N	-1	1647a00d-03d4-484f-9747-7f10f7eb2088
86	17	2019-07-19T13:29:29Z	\N	1	\N	-1	1647a00d-03d4-484f-9747-7f10f7eb2088
87	18	2019-07-19T13:29:29Z	\N	1	\N	-1	1647a00d-03d4-484f-9747-7f10f7eb2088
88	34	Made available in DSpace on 2019-07-19T13:29:29Z (GMT). No. of bitstreams: 2\n007A5P4F1-07.jpg: 4925771 bytes, checksum: 389e0edd4df7a72475d0fb8df974e494 (MD5)\n007A5P4F1-07.jpg.jpg: 133728 bytes, checksum: ff9c50d233e593e87812ccfc39125bac (MD5)	en	1	\N	-1	1647a00d-03d4-484f-9747-7f10f7eb2088
89	32	Generated Thumbnail	\N	0	\N	-1	adfc389d-5537-472c-9a51-4f1bd18b4888
1374	61	Written by FormatFilter org.dspace.app.mediafilter.JPEGFilter on 2019-07-19T13:43:50Z (GMT).	\N	0	\N	-1	d91ce649-f50c-4122-8ad8-0c713d5ac137
1375	32	Generated Thumbnail	\N	0	\N	-1	d91ce649-f50c-4122-8ad8-0c713d5ac137
1376	70	007Marc Ferrez15.jpg.jpg	\N	0	\N	-1	613ee361-f8fb-4ff5-9c55-38f0cb83be45
1377	61	Written by FormatFilter org.dspace.app.mediafilter.JPEGFilter on 2019-07-19T13:43:52Z (GMT).	\N	0	\N	-1	613ee361-f8fb-4ff5-9c55-38f0cb83be45
1378	32	Generated Thumbnail	\N	0	\N	-1	613ee361-f8fb-4ff5-9c55-38f0cb83be45
1379	70	0071824cx019-08.JPG.jpg	\N	0	\N	-1	e7bd4f9d-c802-498d-9aea-c3240c40233b
1380	61	Written by FormatFilter org.dspace.app.mediafilter.JPEGFilter on 2019-07-19T13:43:53Z (GMT).	\N	0	\N	-1	e7bd4f9d-c802-498d-9aea-c3240c40233b
1381	32	Generated Thumbnail	\N	0	\N	-1	e7bd4f9d-c802-498d-9aea-c3240c40233b
1382	70	001AMF015011.jpg.jpg	\N	0	\N	-1	d4cc7466-9447-45fe-8089-d8b8f73341a3
1383	61	Written by FormatFilter org.dspace.app.mediafilter.JPEGFilter on 2019-07-19T13:43:55Z (GMT).	\N	0	\N	-1	d4cc7466-9447-45fe-8089-d8b8f73341a3
1384	32	Generated Thumbnail	\N	0	\N	-1	d4cc7466-9447-45fe-8089-d8b8f73341a3
1385	70	007A5P4F2-02.jpg.jpg	\N	0	\N	-1	a99888bf-e1c8-401b-a755-53ef7f002105
1386	61	Written by FormatFilter org.dspace.app.mediafilter.JPEGFilter on 2019-07-19T13:43:59Z (GMT).	\N	0	\N	-1	a99888bf-e1c8-401b-a755-53ef7f002105
1387	32	Generated Thumbnail	\N	0	\N	-1	a99888bf-e1c8-401b-a755-53ef7f002105
1388	70	002080BR0206.jpg.jpg	\N	0	\N	-1	8c0cd64c-047e-4182-98a2-b28671f7d528
1389	61	Written by FormatFilter org.dspace.app.mediafilter.JPEGFilter on 2019-07-19T13:44:06Z (GMT).	\N	0	\N	-1	8c0cd64c-047e-4182-98a2-b28671f7d528
1390	32	Generated Thumbnail	\N	0	\N	-1	8c0cd64c-047e-4182-98a2-b28671f7d528
97	32	i: 17,6 x 21,1cm  s: 18,8 x 27,1cm	pt_BR	1	\N	-1	6042b9c6-0f1a-4714-863e-0208d96df43a
1391	70	007A5P3F05-14.jpg.jpg	\N	0	\N	-1	7d29847d-6143-4a08-91f1-84ddab82f98c
101	59	Solicitar imagem junto ao detentor dos direitos indicado no Copyright	pt_BR	1	\N	-1	6042b9c6-0f1a-4714-863e-0208d96df43a
1392	61	Written by FormatFilter org.dspace.app.mediafilter.JPEGFilter on 2019-07-19T13:44:08Z (GMT).	\N	0	\N	-1	7d29847d-6143-4a08-91f1-84ddab82f98c
1393	32	Generated Thumbnail	\N	0	\N	-1	7d29847d-6143-4a08-91f1-84ddab82f98c
104	63	COLEÇÃO IMS	pt_BR	1	\N	-1	6042b9c6-0f1a-4714-863e-0208d96df43a
1394	70	002051AM001003.jpg.jpg	\N	0	\N	-1	1be2d800-ff0f-4727-a737-410a5f23c79a
1395	61	Written by FormatFilter org.dspace.app.mediafilter.JPEGFilter on 2019-07-19T13:44:26Z (GMT).	\N	0	\N	-1	1be2d800-ff0f-4727-a737-410a5f23c79a
1396	32	Generated Thumbnail	\N	0	\N	-1	1be2d800-ff0f-4727-a737-410a5f23c79a
112	133	RJ	pt_BR	1	\N	-1	6042b9c6-0f1a-4714-863e-0208d96df43a
115	70	ORIGINAL	\N	1	\N	-1	3b7d13a5-363f-47d1-8cd9-62916736446a
90	7	Gutierrez, Juan	pt_BR	0	\N	-1	6042b9c6-0f1a-4714-863e-0208d96df43a
91	16	1893 circa	pt_BR	0	\N	-1	6042b9c6-0f1a-4714-863e-0208d96df43a
92	17	2017-08-04T20:38:11Z		0	\N	-1	6042b9c6-0f1a-4714-863e-0208d96df43a
93	18	2017-08-04T20:38:11Z		0	\N	-1	6042b9c6-0f1a-4714-863e-0208d96df43a
94	23	002055RevdaArmada023.jpg	pt_BR	0	\N	-1	6042b9c6-0f1a-4714-863e-0208d96df43a
1397	70	007A5P3FG5-13.jpg.jpg	\N	0	\N	-1	d172edee-f13d-4095-812e-b46560b14436
96	32	MONOCROMÁTICA	pt_BR	0	\N	-1	6042b9c6-0f1a-4714-863e-0208d96df43a
98	32	Albumina/ Prata	pt_BR	2	\N	-1	6042b9c6-0f1a-4714-863e-0208d96df43a
99	34	Made available in DSpace on 2017-08-04T20:38:11Z (GMT). No. of bitstreams: 1\n002055RevdaArmada023.jpg: 2383066 bytes, checksum: ffd8592a32c894c082ca7438ee59df83 (MD5)	en	0	\N	-1	6042b9c6-0f1a-4714-863e-0208d96df43a
100	59	Instituto Moreira Salles	pt_BR	0	\N	-1	6042b9c6-0f1a-4714-863e-0208d96df43a
102	61	Coleção Instituto Moreira Salles	pt_BR	0	\N	-1	6042b9c6-0f1a-4714-863e-0208d96df43a
103	63	Guerras / Revoltas / Revoluções	pt_BR	0	\N	-1	6042b9c6-0f1a-4714-863e-0208d96df43a
105	63	Diurna	pt_BR	2	\N	-1	6042b9c6-0f1a-4714-863e-0208d96df43a
106	63	REVOLTA DA ARMADA	pt_BR	3	\N	-1	6042b9c6-0f1a-4714-863e-0208d96df43a
107	63	Externa	pt_BR	4	\N	-1	6042b9c6-0f1a-4714-863e-0208d96df43a
108	63	JUAN GUTIERREZ	pt_BR	5	\N	-1	6042b9c6-0f1a-4714-863e-0208d96df43a
109	70	Revolta da armada - Ruínas de Villegaignon	pt_BR	0	\N	-1	6042b9c6-0f1a-4714-863e-0208d96df43a
110	72	Fotografia/ Papel	pt_BR	0	\N	-1	6042b9c6-0f1a-4714-863e-0208d96df43a
111	133	Rio de Janeiro	pt_BR	0	\N	-1	6042b9c6-0f1a-4714-863e-0208d96df43a
113	133	Brasil	pt_BR	2	\N	-1	6042b9c6-0f1a-4714-863e-0208d96df43a
114	133	Forte de Villegaignon	pt_BR	3	\N	-1	6042b9c6-0f1a-4714-863e-0208d96df43a
116	70	002055RevdaArmada023.jpg	\N	0	\N	-1	0c7568f7-0a7a-47cb-890b-45e76342b112
117	70	THUMBNAIL	\N	1	\N	-1	df393130-4c6e-4939-aa32-06db82f60c5e
118	70	002055RevdaArmada023.jpg.jpg	\N	0	\N	-1	cd7ec348-a758-43d9-9cfa-dc1bd4f43036
119	31	https://hdl.handle.net/20.500.12156.1/5276	\N	0	\N	-1	6042b9c6-0f1a-4714-863e-0208d96df43a
120	17	2019-07-19T13:29:31Z	\N	1	\N	-1	6042b9c6-0f1a-4714-863e-0208d96df43a
121	18	2019-07-19T13:29:31Z	\N	1	\N	-1	6042b9c6-0f1a-4714-863e-0208d96df43a
122	34	Made available in DSpace on 2019-07-19T13:29:31Z (GMT). No. of bitstreams: 2\n002055RevdaArmada023.jpg: 2383066 bytes, checksum: ffd8592a32c894c082ca7438ee59df83 (MD5)\n002055RevdaArmada023.jpg.jpg: 134632 bytes, checksum: 4fc0a68f990a115c2ce8f331385a474e (MD5)	en	1	\N	-1	6042b9c6-0f1a-4714-863e-0208d96df43a
123	32	Generated Thumbnail	\N	0	\N	-1	cd7ec348-a758-43d9-9cfa-dc1bd4f43036
1398	61	Written by FormatFilter org.dspace.app.mediafilter.JPEGFilter on 2019-07-19T13:44:28Z (GMT).	\N	0	\N	-1	d172edee-f13d-4095-812e-b46560b14436
1399	32	Generated Thumbnail	\N	0	\N	-1	d172edee-f13d-4095-812e-b46560b14436
1400	70	002080Vol01Cx0307.jpg.jpg	\N	0	\N	-1	3c2219e1-2aba-4858-b771-0da4ac35b418
1401	61	Written by FormatFilter org.dspace.app.mediafilter.JPEGFilter on 2019-07-19T13:44:29Z (GMT).	\N	0	\N	-1	3c2219e1-2aba-4858-b771-0da4ac35b418
1402	32	Generated Thumbnail	\N	0	\N	-1	3c2219e1-2aba-4858-b771-0da4ac35b418
1403	70	0072137cx010.JPG.jpg	\N	0	\N	-1	1dde7599-3b2c-49f5-ace4-51aeabf047ed
1404	61	Written by FormatFilter org.dspace.app.mediafilter.JPEGFilter on 2019-07-19T13:44:30Z (GMT).	\N	0	\N	-1	1dde7599-3b2c-49f5-ace4-51aeabf047ed
1405	32	Generated Thumbnail	\N	0	\N	-1	1dde7599-3b2c-49f5-ace4-51aeabf047ed
1406	70	007A5P4F1-13.jpg.jpg	\N	0	\N	-1	49ad1cdd-954c-4cf1-8918-1cd7761d072a
1407	61	Written by FormatFilter org.dspace.app.mediafilter.JPEGFilter on 2019-07-19T13:44:31Z (GMT).	\N	0	\N	-1	49ad1cdd-954c-4cf1-8918-1cd7761d072a
1408	32	Generated Thumbnail	\N	0	\N	-1	49ad1cdd-954c-4cf1-8918-1cd7761d072a
1409	70	007A5P3FG2-51.jpg.jpg	\N	0	\N	-1	0648c94a-8301-46dd-81e1-b1c8720f72ca
1410	61	Written by FormatFilter org.dspace.app.mediafilter.JPEGFilter on 2019-07-19T13:44:32Z (GMT).	\N	0	\N	-1	0648c94a-8301-46dd-81e1-b1c8720f72ca
1411	32	Generated Thumbnail	\N	0	\N	-1	0648c94a-8301-46dd-81e1-b1c8720f72ca
131	32	17,1 x 23,2 cm	pt_BR	1	\N	-1	4e20305a-a171-4533-bb0d-0fde80140a82
1412	1	Ying	\N	0	\N	-1	0a1b1544-c449-4d3c-954e-eacbf84f3e48
135	59	Solicitar imagem junto ao detentor dos direitos indicado no Copyright	pt_BR	1	\N	-1	4e20305a-a171-4533-bb0d-0fde80140a82
1413	2	Jin	\N	0	\N	-1	0a1b1544-c449-4d3c-954e-eacbf84f3e48
137	63	Horizontal	pt_BR	1	\N	-1	4e20305a-a171-4533-bb0d-0fde80140a82
1414	3	713-348-8082	\N	0	\N	-1	0a1b1544-c449-4d3c-954e-eacbf84f3e48
1415	1	Monica	\N	0	\N	-1	04be2760-8cdd-462c-b9cd-fb60e862c136
1416	2	Rivero	\N	0	\N	-1	04be2760-8cdd-462c-b9cd-fb60e862c136
1417	3	713-348-8086	\N	0	\N	-1	04be2760-8cdd-462c-b9cd-fb60e862c136
145	133	Centro; Chácara da Floresta, no alto do Morro do Castelo	pt_BR	1	\N	-1	4e20305a-a171-4533-bb0d-0fde80140a82
148	70	ORIGINAL	\N	1	\N	-1	49c37abb-eb40-4511-bfa4-85b47f4f9078
124	7	Malta, Augusto	pt_BR	0	\N	-1	4e20305a-a171-4533-bb0d-0fde80140a82
125	16	1922/01/05	pt_BR	0	\N	-1	4e20305a-a171-4533-bb0d-0fde80140a82
126	17	2016-06-20T14:06:29Z		0	\N	-1	4e20305a-a171-4533-bb0d-0fde80140a82
127	18	2016-06-20T14:06:29Z		0	\N	-1	4e20305a-a171-4533-bb0d-0fde80140a82
128	23	014AM005012.jpg	pt_BR	0	\N	-1	4e20305a-a171-4533-bb0d-0fde80140a82
130	32	P&B	pt_BR	0	\N	-1	4e20305a-a171-4533-bb0d-0fde80140a82
132	32	Gelatina/ Prata	pt_BR	2	\N	-1	4e20305a-a171-4533-bb0d-0fde80140a82
133	34	Made available in DSpace on 2016-06-20T14:06:29Z (GMT). No. of bitstreams: 1\n014AM005012.jpg: 19802531 bytes, checksum: 6913773463e6ae555de36a6bc4a053b0 (MD5)	en	0	\N	-1	4e20305a-a171-4533-bb0d-0fde80140a82
134	59	Instituto Moreira Salles	pt_BR	0	\N	-1	4e20305a-a171-4533-bb0d-0fde80140a82
136	63	Engenharia	pt_BR	0	\N	-1	4e20305a-a171-4533-bb0d-0fde80140a82
138	63	Morro do Castelo	pt_BR	2	\N	-1	4e20305a-a171-4533-bb0d-0fde80140a82
139	63	Externa	pt_BR	3	\N	-1	4e20305a-a171-4533-bb0d-0fde80140a82
140	63	PEDRO CORRÊA do LAGO	pt_BR	4	\N	-1	4e20305a-a171-4533-bb0d-0fde80140a82
141	63	Obras e demolições	pt_BR	5	\N	-1	4e20305a-a171-4533-bb0d-0fde80140a82
142	70	Demolição do Morro do Castelo	pt_BR	0	\N	-1	4e20305a-a171-4533-bb0d-0fde80140a82
143	72	Fotografia/ Papel	pt_BR	0	\N	-1	4e20305a-a171-4533-bb0d-0fde80140a82
144	133	Rio de Janeiro	pt_BR	0	\N	-1	4e20305a-a171-4533-bb0d-0fde80140a82
146	133	RJ	pt_BR	2	\N	-1	4e20305a-a171-4533-bb0d-0fde80140a82
147	133	Brasil	pt_BR	3	\N	-1	4e20305a-a171-4533-bb0d-0fde80140a82
149	70	014AM005012.jpg	\N	0	\N	-1	2211fbd7-3a2d-429d-bae7-ecab96049a46
150	70	THUMBNAIL	\N	1	\N	-1	3f33561d-885f-4ada-bb9e-40909ce55a83
151	70	014AM005012.jpg.jpg	\N	0	\N	-1	f4792a10-994e-470f-a2f6-c24017cc93cb
152	31	https://hdl.handle.net/20.500.12156.1/4651	\N	0	\N	-1	4e20305a-a171-4533-bb0d-0fde80140a82
153	17	2019-07-19T13:29:35Z	\N	1	\N	-1	4e20305a-a171-4533-bb0d-0fde80140a82
154	18	2019-07-19T13:29:35Z	\N	1	\N	-1	4e20305a-a171-4533-bb0d-0fde80140a82
155	34	Made available in DSpace on 2019-07-19T13:29:35Z (GMT). No. of bitstreams: 2\n014AM005012.jpg: 19802531 bytes, checksum: 6913773463e6ae555de36a6bc4a053b0 (MD5)\n014AM005012.jpg.jpg: 212383 bytes, checksum: 1563eb80d860861affcc6b726b7f393e (MD5)	en	1	\N	-1	4e20305a-a171-4533-bb0d-0fde80140a82
156	32	Generated Thumbnail	\N	0	\N	-1	f4792a10-994e-470f-a2f6-c24017cc93cb
164	32	i: 17,0 x 22,5 cm	pt_BR	1	\N	-1	f0ea3089-84e1-4a9a-9817-16d15100fb54
168	59	Solicitar imagem junto ao detentor dos direitos indicado no Copyright	pt_BR	1	\N	-1	f0ea3089-84e1-4a9a-9817-16d15100fb54
171	63	GILBERTO FERREZ	pt_BR	1	\N	-1	f0ea3089-84e1-4a9a-9817-16d15100fb54
1418	1	Ualas	\N	0	\N	-1	09793dde-5685-4605-828a-10313dbc2a1d
1419	2	Barreto Rohrer	\N	0	\N	-1	09793dde-5685-4605-828a-10313dbc2a1d
1420	3	713-348-4777	\N	0	\N	-1	09793dde-5685-4605-828a-10313dbc2a1d
180	133	RJ	pt_BR	1	\N	-1	f0ea3089-84e1-4a9a-9817-16d15100fb54
182	70	ORIGINAL	\N	1	\N	-1	105ac278-02a6-41d7-aa6b-4e0573bf2ee7
157	7	Ferrez, Marc	pt_BR	0	\N	-1	f0ea3089-84e1-4a9a-9817-16d15100fb54
158	16	1880 circa	pt_BR	0	\N	-1	f0ea3089-84e1-4a9a-9817-16d15100fb54
159	17	2015-04-16T12:53:41Z		0	\N	-1	f0ea3089-84e1-4a9a-9817-16d15100fb54
160	18	2015-04-16T12:53:41Z		0	\N	-1	f0ea3089-84e1-4a9a-9817-16d15100fb54
161	23	007A6P4FP15-10.jpg	pt_BR	0	\N	-1	f0ea3089-84e1-4a9a-9817-16d15100fb54
163	32	MONOCROMÁTICA	pt_BR	0	\N	-1	f0ea3089-84e1-4a9a-9817-16d15100fb54
165	32	Albumina/ Prata	pt_BR	2	\N	-1	f0ea3089-84e1-4a9a-9817-16d15100fb54
166	34	Made available in DSpace on 2015-04-16T12:53:41Z (GMT). No. of bitstreams: 1\n007A6P4FP15-10.jpg: 2129731 bytes, checksum: deb00a29736cb8046dab125feb8925c6 (MD5)	en	0	\N	-1	f0ea3089-84e1-4a9a-9817-16d15100fb54
167	59	Instituto Moreira Salles	pt_BR	0	\N	-1	f0ea3089-84e1-4a9a-9817-16d15100fb54
169	61	Gilberto Ferrez	pt_BR	0	\N	-1	f0ea3089-84e1-4a9a-9817-16d15100fb54
170	63	Aérea	pt_BR	0	\N	-1	f0ea3089-84e1-4a9a-9817-16d15100fb54
172	63	Horizontal	pt_BR	2	\N	-1	f0ea3089-84e1-4a9a-9817-16d15100fb54
173	63	Acidente Geográfico	pt_BR	3	\N	-1	f0ea3089-84e1-4a9a-9817-16d15100fb54
174	63	Diurna	pt_BR	4	\N	-1	f0ea3089-84e1-4a9a-9817-16d15100fb54
175	63	Externa	pt_BR	5	\N	-1	f0ea3089-84e1-4a9a-9817-16d15100fb54
176	63	Paisagem	pt_BR	6	\N	-1	f0ea3089-84e1-4a9a-9817-16d15100fb54
177	70	Vista panorâmica da enseada de Botafogo	pt_BR	0	\N	-1	f0ea3089-84e1-4a9a-9817-16d15100fb54
178	72	Fotografia	pt_BR	0	\N	-1	f0ea3089-84e1-4a9a-9817-16d15100fb54
179	133	Rio de Janeiro	pt_BR	0	\N	-1	f0ea3089-84e1-4a9a-9817-16d15100fb54
181	133	Brasil	pt_BR	2	\N	-1	f0ea3089-84e1-4a9a-9817-16d15100fb54
183	70	007A6P4FP15-10.jpg	\N	0	\N	-1	cbced2d8-7ca1-40e2-9c14-b9673c4e78ef
184	70	THUMBNAIL	\N	1	\N	-1	120ef5da-fc4e-4952-b8a8-4ffd42fc6fe9
185	70	007A6P4FP15-10.jpg.jpg	\N	0	\N	-1	19c8f7f2-27e1-4c00-b1ed-7335499e13d9
186	31	https://hdl.handle.net/20.500.12156.1/2514	\N	0	\N	-1	f0ea3089-84e1-4a9a-9817-16d15100fb54
187	17	2019-07-19T13:29:35Z	\N	1	\N	-1	f0ea3089-84e1-4a9a-9817-16d15100fb54
188	18	2019-07-19T13:29:35Z	\N	1	\N	-1	f0ea3089-84e1-4a9a-9817-16d15100fb54
189	34	Made available in DSpace on 2019-07-19T13:29:35Z (GMT). No. of bitstreams: 2\n007A6P4FP15-10.jpg: 2129731 bytes, checksum: deb00a29736cb8046dab125feb8925c6 (MD5)\n007A6P4FP15-10.jpg.jpg: 106140 bytes, checksum: 965c40a52589638142eaabff6ab15a75 (MD5)	en	1	\N	-1	f0ea3089-84e1-4a9a-9817-16d15100fb54
190	32	Generated Thumbnail	\N	0	\N	-1	19c8f7f2-27e1-4c00-b1ed-7335499e13d9
198	32	i: 17,4 x 23,1 cm	pt_BR	1	\N	-1	edbc5bff-4b36-4b31-b08b-ef5b67d01a74
202	59	Solicitar imagem junto ao detentor dos direitos indicado no Copyright	pt_BR	1	\N	-1	edbc5bff-4b36-4b31-b08b-ef5b67d01a74
205	63	Mar / Oceano	pt_BR	1	\N	-1	edbc5bff-4b36-4b31-b08b-ef5b67d01a74
212	133	Lapa	pt_BR	1	\N	-1	edbc5bff-4b36-4b31-b08b-ef5b67d01a74
215	70	ORIGINAL	\N	1	\N	-1	5a9aa0c7-bca9-4b61-acf6-087fd97eb722
191	7	Malta, Augusto	pt_BR	0	\N	-1	edbc5bff-4b36-4b31-b08b-ef5b67d01a74
192	16	1921	pt_BR	0	\N	-1	edbc5bff-4b36-4b31-b08b-ef5b67d01a74
193	17	2015-04-16T12:55:29Z		0	\N	-1	edbc5bff-4b36-4b31-b08b-ef5b67d01a74
194	18	2015-04-16T12:55:29Z		0	\N	-1	edbc5bff-4b36-4b31-b08b-ef5b67d01a74
195	23	014AM008001.jpg	pt_BR	0	\N	-1	edbc5bff-4b36-4b31-b08b-ef5b67d01a74
197	32	P&B	pt_BR	0	\N	-1	edbc5bff-4b36-4b31-b08b-ef5b67d01a74
199	32	Gelatina/ Prata	pt_BR	2	\N	-1	edbc5bff-4b36-4b31-b08b-ef5b67d01a74
200	34	Made available in DSpace on 2015-04-16T12:55:29Z (GMT). No. of bitstreams: 1\n014AM008001.jpg: 22153446 bytes, checksum: df07b723e7122ce21a3a0d14d03de600 (MD5)	en	0	\N	-1	edbc5bff-4b36-4b31-b08b-ef5b67d01a74
201	59	Instituto Moreira Salles	pt_BR	0	\N	-1	edbc5bff-4b36-4b31-b08b-ef5b67d01a74
203	61	Pedro Corrêa do Lago	pt_BR	0	\N	-1	edbc5bff-4b36-4b31-b08b-ef5b67d01a74
204	63	Horizontal	pt_BR	0	\N	-1	edbc5bff-4b36-4b31-b08b-ef5b67d01a74
206	63	Diurna	pt_BR	2	\N	-1	edbc5bff-4b36-4b31-b08b-ef5b67d01a74
207	63	Externa	pt_BR	3	\N	-1	edbc5bff-4b36-4b31-b08b-ef5b67d01a74
208	63	PEDRO CORRÊA do LAGO	pt_BR	4	\N	-1	edbc5bff-4b36-4b31-b08b-ef5b67d01a74
209	70	Ressaca em frente ao Passeio Público	pt_BR	0	\N	-1	edbc5bff-4b36-4b31-b08b-ef5b67d01a74
210	72	Fotografia/ Papel	pt_BR	0	\N	-1	edbc5bff-4b36-4b31-b08b-ef5b67d01a74
211	133	Rio de Janeiro	pt_BR	0	\N	-1	edbc5bff-4b36-4b31-b08b-ef5b67d01a74
213	133	RJ	pt_BR	2	\N	-1	edbc5bff-4b36-4b31-b08b-ef5b67d01a74
214	133	Brasil	pt_BR	3	\N	-1	edbc5bff-4b36-4b31-b08b-ef5b67d01a74
216	70	014AM008001.jpg	\N	0	\N	-1	a94555aa-4aab-4229-a822-94f5f8c35f2c
217	70	THUMBNAIL	\N	1	\N	-1	b77baa82-dccc-436e-b001-15055196e25e
218	70	014AM008001.jpg.jpg	\N	0	\N	-1	80d5242e-9daa-4a21-be6e-e461263c49b4
219	31	https://hdl.handle.net/20.500.12156.1/2741	\N	0	\N	-1	edbc5bff-4b36-4b31-b08b-ef5b67d01a74
220	17	2019-07-19T13:29:39Z	\N	1	\N	-1	edbc5bff-4b36-4b31-b08b-ef5b67d01a74
221	18	2019-07-19T13:29:39Z	\N	1	\N	-1	edbc5bff-4b36-4b31-b08b-ef5b67d01a74
222	34	Made available in DSpace on 2019-07-19T13:29:39Z (GMT). No. of bitstreams: 2\n014AM008001.jpg: 22153446 bytes, checksum: df07b723e7122ce21a3a0d14d03de600 (MD5)\n014AM008001.jpg.jpg: 131732 bytes, checksum: ff708c85b9491952be78b712e1c46776 (MD5)	en	1	\N	-1	edbc5bff-4b36-4b31-b08b-ef5b67d01a74
223	32	Generated Thumbnail	\N	0	\N	-1	80d5242e-9daa-4a21-be6e-e461263c49b4
231	32	i/sp: 17,4 x 23,2 cm	pt_BR	1	\N	-1	f5487302-92d0-4914-89f6-2190c49f4ced
235	59	Solicitar imagem junto ao detentor dos direitos indicado no Copyright	pt_BR	1	\N	-1	f5487302-92d0-4914-89f6-2190c49f4ced
238	63	Cena de rua	pt_BR	1	\N	-1	f5487302-92d0-4914-89f6-2190c49f4ced
246	133	Lapa	pt_BR	1	\N	-1	f5487302-92d0-4914-89f6-2190c49f4ced
249	70	ORIGINAL	\N	1	\N	-1	4d9f173b-7552-4326-ac76-a0950e387ec8
224	7	Malta, Augusto	pt_BR	0	\N	-1	f5487302-92d0-4914-89f6-2190c49f4ced
225	16	1928	pt_BR	0	\N	-1	f5487302-92d0-4914-89f6-2190c49f4ced
226	17	2015-04-16T12:55:31Z		0	\N	-1	f5487302-92d0-4914-89f6-2190c49f4ced
227	18	2015-04-16T12:55:31Z		0	\N	-1	f5487302-92d0-4914-89f6-2190c49f4ced
228	23	014AM010011.jpg	pt_BR	0	\N	-1	f5487302-92d0-4914-89f6-2190c49f4ced
230	32	P&B	pt_BR	0	\N	-1	f5487302-92d0-4914-89f6-2190c49f4ced
232	32	Gelatina/ Prata	pt_BR	2	\N	-1	f5487302-92d0-4914-89f6-2190c49f4ced
233	34	Made available in DSpace on 2015-04-16T12:55:31Z (GMT). No. of bitstreams: 1\n014AM010011.jpg: 19259494 bytes, checksum: 2d1bd84000abff9bb1ab4d471dcfb4bb (MD5)	en	0	\N	-1	f5487302-92d0-4914-89f6-2190c49f4ced
234	59	Instituto Moreira Salles	pt_BR	0	\N	-1	f5487302-92d0-4914-89f6-2190c49f4ced
236	61	Pedro Corrêa do Lago	pt_BR	0	\N	-1	f5487302-92d0-4914-89f6-2190c49f4ced
237	63	Aspectos Urbanos	pt_BR	0	\N	-1	f5487302-92d0-4914-89f6-2190c49f4ced
239	63	Horizontal	pt_BR	2	\N	-1	f5487302-92d0-4914-89f6-2190c49f4ced
240	63	Diurna	pt_BR	3	\N	-1	f5487302-92d0-4914-89f6-2190c49f4ced
241	63	Externa	pt_BR	4	\N	-1	f5487302-92d0-4914-89f6-2190c49f4ced
242	63	PEDRO CORRÊA do LAGO	pt_BR	5	\N	-1	f5487302-92d0-4914-89f6-2190c49f4ced
243	70	Mudança de calçamento na rua dos Arcos	pt_BR	0	\N	-1	f5487302-92d0-4914-89f6-2190c49f4ced
244	72	Fotografia/ Papel	pt_BR	0	\N	-1	f5487302-92d0-4914-89f6-2190c49f4ced
245	133	Rio de Janeiro	pt_BR	0	\N	-1	f5487302-92d0-4914-89f6-2190c49f4ced
247	133	RJ	pt_BR	2	\N	-1	f5487302-92d0-4914-89f6-2190c49f4ced
248	133	Brasil	pt_BR	3	\N	-1	f5487302-92d0-4914-89f6-2190c49f4ced
250	70	014AM010011.jpg	\N	0	\N	-1	dc0680b6-5534-4091-9619-f945e80a308b
251	70	THUMBNAIL	\N	1	\N	-1	e6dd77b8-988c-415e-83c4-9e6003c237a7
252	70	014AM010011.jpg.jpg	\N	0	\N	-1	3ff42a9b-4597-44ae-91aa-a5c6b087e14c
253	31	https://hdl.handle.net/20.500.12156.1/2747	\N	0	\N	-1	f5487302-92d0-4914-89f6-2190c49f4ced
254	17	2019-07-19T13:29:41Z	\N	1	\N	-1	f5487302-92d0-4914-89f6-2190c49f4ced
255	18	2019-07-19T13:29:41Z	\N	1	\N	-1	f5487302-92d0-4914-89f6-2190c49f4ced
256	34	Made available in DSpace on 2019-07-19T13:29:41Z (GMT). No. of bitstreams: 2\n014AM010011.jpg: 19259494 bytes, checksum: 2d1bd84000abff9bb1ab4d471dcfb4bb (MD5)\n014AM010011.jpg.jpg: 156163 bytes, checksum: eb0be42f43e9fb768e04959857826c90 (MD5)	en	1	\N	-1	f5487302-92d0-4914-89f6-2190c49f4ced
257	32	Generated Thumbnail	\N	0	\N	-1	3ff42a9b-4597-44ae-91aa-a5c6b087e14c
265	32	i/sp: 17,7 x 23,4 cm	pt_BR	1	\N	-1	b8684970-4418-4f5b-a99a-c46ed5721710
269	59	Solicitar imagem junto ao detentor dos direitos indicado no Copyright	pt_BR	1	\N	-1	b8684970-4418-4f5b-a99a-c46ed5721710
275	133	Igreja da Imperial Irmandade de Nossa Senhora do Rosário e São Benedito dos Homens Pretos; rua Uruguaiana; Centro	pt_BR	1	\N	-1	b8684970-4418-4f5b-a99a-c46ed5721710
278	70	ORIGINAL	\N	1	\N	-1	8ba24c03-9683-4bd5-8182-63a1188df55e
258	7	Malta, Augusto	pt_BR	0	\N	-1	b8684970-4418-4f5b-a99a-c46ed5721710
259	16	1922/01/09	pt_BR	0	\N	-1	b8684970-4418-4f5b-a99a-c46ed5721710
260	17	2016-11-30T19:25:58Z		0	\N	-1	b8684970-4418-4f5b-a99a-c46ed5721710
261	18	2016-11-30T19:25:58Z		0	\N	-1	b8684970-4418-4f5b-a99a-c46ed5721710
262	23	014AM017006.jpg	pt_BR	0	\N	-1	b8684970-4418-4f5b-a99a-c46ed5721710
264	32	P&B	pt_BR	0	\N	-1	b8684970-4418-4f5b-a99a-c46ed5721710
266	32	Gelatina/ Prata	pt_BR	2	\N	-1	b8684970-4418-4f5b-a99a-c46ed5721710
267	34	Made available in DSpace on 2016-11-30T19:25:58Z (GMT). No. of bitstreams: 1\r\n014AM017006.jpg: 3783208 bytes, checksum: 8a853a2d8afdd8c3a8fc3e864694dc7d (MD5)	en	0	\N	-1	b8684970-4418-4f5b-a99a-c46ed5721710
268	59	Instituto Moreira Salles	pt_BR	0	\N	-1	b8684970-4418-4f5b-a99a-c46ed5721710
270	61	Coleção Pedro Corrêa do Lago	pt_BR	0	\N	-1	b8684970-4418-4f5b-a99a-c46ed5721710
271	63	Eventos e Comemorações - Dia do Fico	pt_BR	0	\N	-1	b8684970-4418-4f5b-a99a-c46ed5721710
272	70	Evento de comemoração aos cem anos do Dia do Fico, em frente a	pt_BR	0	\N	-1	b8684970-4418-4f5b-a99a-c46ed5721710
273	72	Fotografia/ Papel	pt_BR	0	\N	-1	b8684970-4418-4f5b-a99a-c46ed5721710
274	133	Rio de Janeiro	pt_BR	0	\N	-1	b8684970-4418-4f5b-a99a-c46ed5721710
276	133	RJ	pt_BR	2	\N	-1	b8684970-4418-4f5b-a99a-c46ed5721710
277	133	Brasil	pt_BR	3	\N	-1	b8684970-4418-4f5b-a99a-c46ed5721710
279	70	014AM017006.jpg	\N	0	\N	-1	0107af4a-0e80-4d48-bceb-57e088cd92b0
280	70	THUMBNAIL	\N	1	\N	-1	9ba1ff9a-0530-4abb-aade-a84ee2415616
281	70	014AM017006.jpg.jpg	\N	0	\N	-1	7d3525be-a86f-455c-810a-10f048c124d0
282	31	https://hdl.handle.net/20.500.12156.1/4778	\N	0	\N	-1	b8684970-4418-4f5b-a99a-c46ed5721710
283	17	2019-07-19T13:29:43Z	\N	1	\N	-1	b8684970-4418-4f5b-a99a-c46ed5721710
284	18	2019-07-19T13:29:43Z	\N	1	\N	-1	b8684970-4418-4f5b-a99a-c46ed5721710
285	34	Made available in DSpace on 2019-07-19T13:29:43Z (GMT). No. of bitstreams: 2\n014AM017006.jpg: 3783208 bytes, checksum: 8a853a2d8afdd8c3a8fc3e864694dc7d (MD5)\n014AM017006.jpg.jpg: 168981 bytes, checksum: 12178719b08b72c4ff507250ccdc775e (MD5)	en	1	\N	-1	b8684970-4418-4f5b-a99a-c46ed5721710
286	32	Generated Thumbnail	\N	0	\N	-1	7d3525be-a86f-455c-810a-10f048c124d0
294	32	i: 22,1 x 16,4 cm; sp: 23,0 x 12,3 cm	pt_BR	1	\N	-1	f0c85891-e655-4e8e-a6ba-eabba6fdfc97
298	59	Solicitar imagem junto ao detentor dos direitos indicado no Copyright	pt_BR	1	\N	-1	f0c85891-e655-4e8e-a6ba-eabba6fdfc97
301	63	GILBERTO FERREZ	pt_BR	1	\N	-1	f0c85891-e655-4e8e-a6ba-eabba6fdfc97
311	133	RJ	pt_BR	1	\N	-1	f0c85891-e655-4e8e-a6ba-eabba6fdfc97
313	70	ORIGINAL	\N	1	\N	-1	70fdd62c-343b-4d75-b628-2040c97479e8
287	7	Ferrez, Marc	pt_BR	0	\N	-1	f0c85891-e655-4e8e-a6ba-eabba6fdfc97
288	16	1886 circa	pt_BR	0	\N	-1	f0c85891-e655-4e8e-a6ba-eabba6fdfc97
289	17	2016-11-23T12:36:30Z		0	\N	-1	f0c85891-e655-4e8e-a6ba-eabba6fdfc97
290	18	2016-11-23T12:36:30Z		0	\N	-1	f0c85891-e655-4e8e-a6ba-eabba6fdfc97
291	23	007A5P3F03-24.jpg	pt_BR	0	\N	-1	f0c85891-e655-4e8e-a6ba-eabba6fdfc97
293	32	P&B	pt_BR	0	\N	-1	f0c85891-e655-4e8e-a6ba-eabba6fdfc97
295	32	Gelatina/ Prata	pt_BR	2	\N	-1	f0c85891-e655-4e8e-a6ba-eabba6fdfc97
296	34	Made available in DSpace on 2016-11-23T12:36:30Z (GMT). No. of bitstreams: 1\n007A5P3F03-24.jpg: 4471840 bytes, checksum: 79d167962f45f563cf47b63bf9d3d44b (MD5)	en	0	\N	-1	f0c85891-e655-4e8e-a6ba-eabba6fdfc97
297	59	Instituto Moreira Salles	pt_BR	0	\N	-1	f0c85891-e655-4e8e-a6ba-eabba6fdfc97
299	61	Coleção Gilberto Ferrez	pt_BR	0	\N	-1	f0c85891-e655-4e8e-a6ba-eabba6fdfc97
300	63	Panorama	pt_BR	0	\N	-1	f0c85891-e655-4e8e-a6ba-eabba6fdfc97
302	63	Vertical	pt_BR	2	\N	-1	f0c85891-e655-4e8e-a6ba-eabba6fdfc97
303	63	Acidente Geográfico	pt_BR	3	\N	-1	f0c85891-e655-4e8e-a6ba-eabba6fdfc97
304	63	Flora / Vegetação	pt_BR	4	\N	-1	f0c85891-e655-4e8e-a6ba-eabba6fdfc97
305	63	Diurna	pt_BR	5	\N	-1	f0c85891-e655-4e8e-a6ba-eabba6fdfc97
306	63	Externa	pt_BR	6	\N	-1	f0c85891-e655-4e8e-a6ba-eabba6fdfc97
307	63	Paisagem	pt_BR	7	\N	-1	f0c85891-e655-4e8e-a6ba-eabba6fdfc97
308	70	Corcovado	pt_BR	0	\N	-1	f0c85891-e655-4e8e-a6ba-eabba6fdfc97
309	72	Fotografia/ Papel	pt_BR	0	\N	-1	f0c85891-e655-4e8e-a6ba-eabba6fdfc97
310	133	Rio de Janeiro	pt_BR	0	\N	-1	f0c85891-e655-4e8e-a6ba-eabba6fdfc97
312	133	Brasil	pt_BR	2	\N	-1	f0c85891-e655-4e8e-a6ba-eabba6fdfc97
314	70	007A5P3F03-24.jpg	\N	0	\N	-1	df126add-167e-4004-a3e0-b8b0374f885d
315	70	THUMBNAIL	\N	1	\N	-1	86832dac-4fbe-42d9-8a8d-94a9ce22cf20
316	70	007A5P3F03-24.jpg.jpg	\N	0	\N	-1	19d68051-321e-4f01-9fc8-bbd38ffbbf82
317	31	https://hdl.handle.net/20.500.12156.1/4772	\N	0	\N	-1	f0c85891-e655-4e8e-a6ba-eabba6fdfc97
318	17	2019-07-19T13:29:44Z	\N	1	\N	-1	f0c85891-e655-4e8e-a6ba-eabba6fdfc97
319	18	2019-07-19T13:29:44Z	\N	1	\N	-1	f0c85891-e655-4e8e-a6ba-eabba6fdfc97
320	34	Made available in DSpace on 2019-07-19T13:29:44Z (GMT). No. of bitstreams: 2\n007A5P3F03-24.jpg: 4471840 bytes, checksum: 79d167962f45f563cf47b63bf9d3d44b (MD5)\n007A5P3F03-24.jpg.jpg: 148319 bytes, checksum: 99a9e1ec38de13f2a65c5ed316126811 (MD5)	en	1	\N	-1	f0c85891-e655-4e8e-a6ba-eabba6fdfc97
321	32	Generated Thumbnail	\N	0	\N	-1	19d68051-321e-4f01-9fc8-bbd38ffbbf82
328	32	i/sp: 23,3 x 19,0 cm; ss: 42,5 x 32,4 cm.	pt_BR	1	\N	-1	af4b4244-1e85-4b33-9ca0-c267b1130df0
332	59	Solicitar imagem junto ao detentor dos direitos indicado no Copyright	pt_BR	1	\N	-1	af4b4244-1e85-4b33-9ca0-c267b1130df0
335	63	Acidente Geográfico	pt_BR	1	\N	-1	af4b4244-1e85-4b33-9ca0-c267b1130df0
344	133	RJ	pt_BR	1	\N	-1	af4b4244-1e85-4b33-9ca0-c267b1130df0
346	70	ORIGINAL	\N	1	\N	-1	042e5ec3-7be3-4a30-9009-e6d3839bfda7
322	7	Leuzinger, Georges	pt_BR	0	\N	-1	af4b4244-1e85-4b33-9ca0-c267b1130df0
323	17	2015-04-16T12:51:00Z		0	\N	-1	af4b4244-1e85-4b33-9ca0-c267b1130df0
324	18	2015-04-16T12:51:00Z		0	\N	-1	af4b4244-1e85-4b33-9ca0-c267b1130df0
325	23	001LE004002.jpg	pt_BR	0	\N	-1	af4b4244-1e85-4b33-9ca0-c267b1130df0
327	32	MONOCROMÁTICA	pt_BR	0	\N	-1	af4b4244-1e85-4b33-9ca0-c267b1130df0
329	32	Albumina/ Prata	pt_BR	2	\N	-1	af4b4244-1e85-4b33-9ca0-c267b1130df0
330	34	Made available in DSpace on 2015-04-16T12:51:00Z (GMT). No. of bitstreams: 1\n001LE004002.jpg: 3746620 bytes, checksum: 42c43012749a55aedfd7b9dabe61fce7 (MD5)	en	0	\N	-1	af4b4244-1e85-4b33-9ca0-c267b1130df0
331	59	Instituto Moreira Salles	pt_BR	0	\N	-1	af4b4244-1e85-4b33-9ca0-c267b1130df0
333	61	Mestres do Séc. XIX	pt_BR	0	\N	-1	af4b4244-1e85-4b33-9ca0-c267b1130df0
334	63	Vertical	pt_BR	0	\N	-1	af4b4244-1e85-4b33-9ca0-c267b1130df0
336	63	Pedra da Gávea	pt_BR	2	\N	-1	af4b4244-1e85-4b33-9ca0-c267b1130df0
337	63	Georges Leuzinger	pt_BR	3	\N	-1	af4b4244-1e85-4b33-9ca0-c267b1130df0
338	63	Flora / Vegetação	pt_BR	4	\N	-1	af4b4244-1e85-4b33-9ca0-c267b1130df0
339	63	Diurna	pt_BR	5	\N	-1	af4b4244-1e85-4b33-9ca0-c267b1130df0
340	63	Externa	pt_BR	6	\N	-1	af4b4244-1e85-4b33-9ca0-c267b1130df0
341	70	Pedra da Gávea	pt_BR	0	\N	-1	af4b4244-1e85-4b33-9ca0-c267b1130df0
342	72	Fotografia/ Papel	pt_BR	0	\N	-1	af4b4244-1e85-4b33-9ca0-c267b1130df0
343	133	Rio de Janeiro	pt_BR	0	\N	-1	af4b4244-1e85-4b33-9ca0-c267b1130df0
345	133	Brasil	pt_BR	2	\N	-1	af4b4244-1e85-4b33-9ca0-c267b1130df0
347	70	001LE004002.jpg	\N	0	\N	-1	c168ef8c-6706-4530-8e60-0162cd97980c
348	70	THUMBNAIL	\N	1	\N	-1	9ea9f933-ee16-4dbd-889d-fdced9321c03
349	70	001LE004002.jpg.jpg	\N	0	\N	-1	b1d0277b-fd8e-4fa3-8fa9-b19ed0a53d56
350	31	https://hdl.handle.net/20.500.12156.1/2028	\N	0	\N	-1	af4b4244-1e85-4b33-9ca0-c267b1130df0
351	17	2019-07-19T13:29:45Z	\N	1	\N	-1	af4b4244-1e85-4b33-9ca0-c267b1130df0
352	18	2019-07-19T13:29:45Z	\N	1	\N	-1	af4b4244-1e85-4b33-9ca0-c267b1130df0
353	34	Made available in DSpace on 2019-07-19T13:29:45Z (GMT). No. of bitstreams: 2\n001LE004002.jpg: 3746620 bytes, checksum: 42c43012749a55aedfd7b9dabe61fce7 (MD5)\n001LE004002.jpg.jpg: 97661 bytes, checksum: 1b77186c4a59e6443efff68076cd63f1 (MD5)	en	1	\N	-1	af4b4244-1e85-4b33-9ca0-c267b1130df0
354	32	Generated Thumbnail	\N	0	\N	-1	b1d0277b-fd8e-4fa3-8fa9-b19ed0a53d56
362	32	4,5 x 11 cm	pt_BR	1	\N	-1	b17e6dc6-cd53-4646-b790-06d1a12ee1ab
366	59	Solicitar imagem junto ao detentor dos direitos indicado no Copyright	pt_BR	1	\N	-1	b17e6dc6-cd53-4646-b790-06d1a12ee1ab
369	63	GUILHERME SANTOS	pt_BR	1	\N	-1	b17e6dc6-cd53-4646-b790-06d1a12ee1ab
375	133	RJ	pt_BR	1	\N	-1	b17e6dc6-cd53-4646-b790-06d1a12ee1ab
377	70	ORIGINAL	\N	1	\N	-1	4cf5e155-be37-4290-93fe-22e3edf55167
355	7	Santos, Guilherme	pt_BR	0	\N	-1	b17e6dc6-cd53-4646-b790-06d1a12ee1ab
356	16	1917	pt_BR	0	\N	-1	b17e6dc6-cd53-4646-b790-06d1a12ee1ab
357	17	2015-04-16T12:51:08Z		0	\N	-1	b17e6dc6-cd53-4646-b790-06d1a12ee1ab
358	18	2015-04-16T12:51:08Z		0	\N	-1	b17e6dc6-cd53-4646-b790-06d1a12ee1ab
359	23	002080BR0207.jpg	pt_BR	0	\N	-1	b17e6dc6-cd53-4646-b790-06d1a12ee1ab
361	32	MONOCROMÁTICA	pt_BR	0	\N	-1	b17e6dc6-cd53-4646-b790-06d1a12ee1ab
363	32	Gelatina/ Prata	pt_BR	2	\N	-1	b17e6dc6-cd53-4646-b790-06d1a12ee1ab
364	34	Made available in DSpace on 2015-04-16T12:51:08Z (GMT). No. of bitstreams: 1\n002080BR0207.jpg: 5113378 bytes, checksum: 579eb1d2ac5224d7b73d9320c41736ff (MD5)	en	0	\N	-1	b17e6dc6-cd53-4646-b790-06d1a12ee1ab
365	59	Instituto Moreira Salles	pt_BR	0	\N	-1	b17e6dc6-cd53-4646-b790-06d1a12ee1ab
367	61	Instituto Moreira Salles	pt_BR	0	\N	-1	b17e6dc6-cd53-4646-b790-06d1a12ee1ab
368	63	Pessoas	pt_BR	0	\N	-1	b17e6dc6-cd53-4646-b790-06d1a12ee1ab
370	63	Jardins / Praças e parques	pt_BR	2	\N	-1	b17e6dc6-cd53-4646-b790-06d1a12ee1ab
371	63	Externa	pt_BR	3	\N	-1	b17e6dc6-cd53-4646-b790-06d1a12ee1ab
372	70	Largo do Machado	pt_BR	0	\N	-1	b17e6dc6-cd53-4646-b790-06d1a12ee1ab
373	72	Diapositivo/ Vidro	pt_BR	0	\N	-1	b17e6dc6-cd53-4646-b790-06d1a12ee1ab
374	133	Rio de Janeiro	pt_BR	0	\N	-1	b17e6dc6-cd53-4646-b790-06d1a12ee1ab
376	133	Brasil	pt_BR	2	\N	-1	b17e6dc6-cd53-4646-b790-06d1a12ee1ab
378	70	002080BR0207.jpg	\N	0	\N	-1	d0aa8a78-9ce7-4527-8208-35d7b34fea8d
379	70	THUMBNAIL	\N	1	\N	-1	0ced5b26-bdcf-47af-96ba-588ad0784150
380	70	002080BR0207.jpg.jpg	\N	0	\N	-1	37c0a70b-6d40-48fe-a528-765a5f6d86ca
381	31	https://hdl.handle.net/20.500.12156.1/2060	\N	0	\N	-1	b17e6dc6-cd53-4646-b790-06d1a12ee1ab
382	17	2019-07-19T13:29:46Z	\N	1	\N	-1	b17e6dc6-cd53-4646-b790-06d1a12ee1ab
383	18	2019-07-19T13:29:46Z	\N	1	\N	-1	b17e6dc6-cd53-4646-b790-06d1a12ee1ab
384	34	Made available in DSpace on 2019-07-19T13:29:46Z (GMT). No. of bitstreams: 2\n002080BR0207.jpg: 5113378 bytes, checksum: 579eb1d2ac5224d7b73d9320c41736ff (MD5)\n002080BR0207.jpg.jpg: 121282 bytes, checksum: 636f9e3eb33df6125eda77ff9928f223 (MD5)	en	1	\N	-1	b17e6dc6-cd53-4646-b790-06d1a12ee1ab
385	32	Generated Thumbnail	\N	0	\N	-1	37c0a70b-6d40-48fe-a528-765a5f6d86ca
393	32	i/sp: 6,0 x 12,5 cm	pt_BR	1	\N	-1	3b3166f9-bb45-486b-bb08-6e2e08901cd4
397	59	Solicitar imagem junto ao detentor dos direitos indicado no Copyright	pt_BR	1	\N	-1	3b3166f9-bb45-486b-bb08-6e2e08901cd4
400	63	Autocromo	pt_BR	1	\N	-1	3b3166f9-bb45-486b-bb08-6e2e08901cd4
408	133	RJ	pt_BR	1	\N	-1	3b3166f9-bb45-486b-bb08-6e2e08901cd4
410	70	ORIGINAL	\N	1	\N	-1	611b0593-f0d8-4a0c-b694-d3143e35a3c8
386	7	Ferrez, Marc	pt_BR	0	\N	-1	3b3166f9-bb45-486b-bb08-6e2e08901cd4
387	16	1922	pt_BR	0	\N	-1	3b3166f9-bb45-486b-bb08-6e2e08901cd4
388	17	2018-07-06T16:04:45Z		0	\N	-1	3b3166f9-bb45-486b-bb08-6e2e08901cd4
389	18	2018-07-06T16:04:45Z		0	\N	-1	3b3166f9-bb45-486b-bb08-6e2e08901cd4
390	23	007_IMG_3381.jpg	pt_BR	0	\N	-1	3b3166f9-bb45-486b-bb08-6e2e08901cd4
392	32	COR	pt_BR	0	\N	-1	3b3166f9-bb45-486b-bb08-6e2e08901cd4
394	32	LANTERN SLIDE / Prata	pt_BR	2	\N	-1	3b3166f9-bb45-486b-bb08-6e2e08901cd4
395	34	Made available in DSpace on 2018-07-06T16:04:45Z (GMT). No. of bitstreams: 1\n007_IMG_3381.jpg: 8518331 bytes, checksum: ce2e6d1c35fcf9aefdb90d3f76f5d55f (MD5)	en	0	\N	-1	3b3166f9-bb45-486b-bb08-6e2e08901cd4
396	59	Instituto Moreira Salles	pt_BR	0	\N	-1	3b3166f9-bb45-486b-bb08-6e2e08901cd4
398	61	Coleção Gilberto Ferrez	pt_BR	0	\N	-1	3b3166f9-bb45-486b-bb08-6e2e08901cd4
399	63	Comércio / Serviços	pt_BR	0	\N	-1	3b3166f9-bb45-486b-bb08-6e2e08901cd4
401	63	Diurna	pt_BR	2	\N	-1	3b3166f9-bb45-486b-bb08-6e2e08901cd4
402	63	Bares e Restaurantes	pt_BR	3	\N	-1	3b3166f9-bb45-486b-bb08-6e2e08901cd4
403	63	COLEÇÃO GILBERTO FERREZ	pt_BR	4	\N	-1	3b3166f9-bb45-486b-bb08-6e2e08901cd4
404	63	Externa	pt_BR	5	\N	-1	3b3166f9-bb45-486b-bb08-6e2e08901cd4
405	70	Restaurante construído para a Exposição do Centenário de 1922	pt_BR	0	\N	-1	3b3166f9-bb45-486b-bb08-6e2e08901cd4
406	72	Diapositivo/ Vidro	pt_BR	0	\N	-1	3b3166f9-bb45-486b-bb08-6e2e08901cd4
407	133	Rio de Janeiro	pt_BR	0	\N	-1	3b3166f9-bb45-486b-bb08-6e2e08901cd4
409	133	Brasil	pt_BR	2	\N	-1	3b3166f9-bb45-486b-bb08-6e2e08901cd4
411	70	007_IMG_3381.jpg	\N	0	\N	-1	001787ca-4021-4448-b6ed-6ff1d56076c0
412	70	THUMBNAIL	\N	1	\N	-1	17130f2d-bc9c-412d-9e9b-6f17d2deaaef
413	70	007_IMG_3381.jpg.jpg	\N	0	\N	-1	95fb37f3-03ae-4005-8266-0e2bad4d3981
414	31	https://hdl.handle.net/20.500.12156.1/5716	\N	0	\N	-1	3b3166f9-bb45-486b-bb08-6e2e08901cd4
415	17	2019-07-19T13:29:48Z	\N	1	\N	-1	3b3166f9-bb45-486b-bb08-6e2e08901cd4
416	18	2019-07-19T13:29:48Z	\N	1	\N	-1	3b3166f9-bb45-486b-bb08-6e2e08901cd4
417	34	Made available in DSpace on 2019-07-19T13:29:48Z (GMT). No. of bitstreams: 2\n007_IMG_3381.jpg: 8518331 bytes, checksum: ce2e6d1c35fcf9aefdb90d3f76f5d55f (MD5)\n007_IMG_3381.jpg.jpg: 172148 bytes, checksum: 13923ae9b47cfc3083e1ae66a9f29fc9 (MD5)	en	1	\N	-1	3b3166f9-bb45-486b-bb08-6e2e08901cd4
418	32	Generated Thumbnail	\N	0	\N	-1	95fb37f3-03ae-4005-8266-0e2bad4d3981
426	32	i: 18,1 x 24,0 cm	pt_BR	1	\N	-1	c82a1191-3a63-4667-bfda-6080261a4069
430	59	Solicitar imagem junto ao detentor dos direitos indicado no Copyright	pt_BR	1	\N	-1	c82a1191-3a63-4667-bfda-6080261a4069
433	63	Cena de rua	pt_BR	1	\N	-1	c82a1191-3a63-4667-bfda-6080261a4069
443	133	Rua Buenos Aires; Centro	pt_BR	1	\N	-1	c82a1191-3a63-4667-bfda-6080261a4069
446	70	ORIGINAL	\N	1	\N	-1	7423f872-ff3a-417c-b5fd-0ab44a56d884
419	7	Malta, Augusto	pt_BR	0	\N	-1	c82a1191-3a63-4667-bfda-6080261a4069
420	16	1920 circa	pt_BR	0	\N	-1	c82a1191-3a63-4667-bfda-6080261a4069
421	17	2015-04-16T12:55:59Z		0	\N	-1	c82a1191-3a63-4667-bfda-6080261a4069
422	18	2015-04-16T12:55:59Z		0	\N	-1	c82a1191-3a63-4667-bfda-6080261a4069
423	23	014AM012038.jpg	pt_BR	0	\N	-1	c82a1191-3a63-4667-bfda-6080261a4069
425	32	P&B	pt_BR	0	\N	-1	c82a1191-3a63-4667-bfda-6080261a4069
427	32	Gelatina/ Prata	pt_BR	2	\N	-1	c82a1191-3a63-4667-bfda-6080261a4069
428	34	Made available in DSpace on 2015-04-16T12:55:59Z (GMT). No. of bitstreams: 1\n014AM012038.jpg: 17394957 bytes, checksum: 76f151c55595a4549e6313c9aae69ca7 (MD5)	en	0	\N	-1	c82a1191-3a63-4667-bfda-6080261a4069
429	59	Instituto Moreira Salles	pt_BR	0	\N	-1	c82a1191-3a63-4667-bfda-6080261a4069
431	61	Pedro Corrêa do Lago	pt_BR	0	\N	-1	c82a1191-3a63-4667-bfda-6080261a4069
432	63	Comércio / Serviços	pt_BR	0	\N	-1	c82a1191-3a63-4667-bfda-6080261a4069
434	63	Aspectos Urbanos	pt_BR	2	\N	-1	c82a1191-3a63-4667-bfda-6080261a4069
435	63	PEDRO CORRÊA do LAGO	pt_BR	3	\N	-1	c82a1191-3a63-4667-bfda-6080261a4069
436	63	Rua Buenos Aires (Rio de Janeiro)	pt_BR	4	\N	-1	c82a1191-3a63-4667-bfda-6080261a4069
437	63	Horizontal	pt_BR	5	\N	-1	c82a1191-3a63-4667-bfda-6080261a4069
438	63	Diurna	pt_BR	6	\N	-1	c82a1191-3a63-4667-bfda-6080261a4069
439	63	Externa	pt_BR	7	\N	-1	c82a1191-3a63-4667-bfda-6080261a4069
440	70	Mercado de Flores	pt_BR	0	\N	-1	c82a1191-3a63-4667-bfda-6080261a4069
441	72	Fotografia/ Papel	pt_BR	0	\N	-1	c82a1191-3a63-4667-bfda-6080261a4069
442	133	Rio de Janeiro	pt_BR	0	\N	-1	c82a1191-3a63-4667-bfda-6080261a4069
444	133	RJ	pt_BR	2	\N	-1	c82a1191-3a63-4667-bfda-6080261a4069
445	133	Brasil	pt_BR	3	\N	-1	c82a1191-3a63-4667-bfda-6080261a4069
447	70	014AM012038.jpg	\N	0	\N	-1	7acced69-4137-4ae6-82aa-d425b7b12cbf
448	70	THUMBNAIL	\N	1	\N	-1	4e2f8ce5-121d-4f09-b736-953c01ffab7c
449	70	014AM012038.jpg.jpg	\N	0	\N	-1	ee62897c-32d2-4b1b-944c-21b83c509d68
450	31	https://hdl.handle.net/20.500.12156.1/2773	\N	0	\N	-1	c82a1191-3a63-4667-bfda-6080261a4069
451	17	2019-07-19T13:29:52Z	\N	1	\N	-1	c82a1191-3a63-4667-bfda-6080261a4069
452	18	2019-07-19T13:29:52Z	\N	1	\N	-1	c82a1191-3a63-4667-bfda-6080261a4069
453	34	Made available in DSpace on 2019-07-19T13:29:52Z (GMT). No. of bitstreams: 2\n014AM012038.jpg: 17394957 bytes, checksum: 76f151c55595a4549e6313c9aae69ca7 (MD5)\n014AM012038.jpg.jpg: 135952 bytes, checksum: 332940645195b94beaca3395a705dc3c (MD5)	en	1	\N	-1	c82a1191-3a63-4667-bfda-6080261a4069
454	32	Generated Thumbnail	\N	0	\N	-1	ee62897c-32d2-4b1b-944c-21b83c509d68
461	32	i/sp: 18,9 x 24,2 cm; ss: 31,2 x 42,0 cm.	pt_BR	1	\N	-1	2a63b298-96d5-4ded-a0fc-e7ca3bcff831
465	59	Solicitar imagem junto ao detentor dos direitos indicado no Copyright	pt_BR	1	\N	-1	2a63b298-96d5-4ded-a0fc-e7ca3bcff831
468	63	Georges Leuzinger	pt_BR	1	\N	-1	2a63b298-96d5-4ded-a0fc-e7ca3bcff831
475	133	Jardim Botânico	pt_BR	1	\N	-1	2a63b298-96d5-4ded-a0fc-e7ca3bcff831
478	70	ORIGINAL	\N	1	\N	-1	a8361706-0b42-4805-8f75-911f1b73b298
455	7	Leuzinger, Georges	pt_BR	0	\N	-1	2a63b298-96d5-4ded-a0fc-e7ca3bcff831
456	17	2015-04-16T12:50:59Z		0	\N	-1	2a63b298-96d5-4ded-a0fc-e7ca3bcff831
457	18	2015-04-16T12:50:59Z		0	\N	-1	2a63b298-96d5-4ded-a0fc-e7ca3bcff831
458	23	001LE002002.jpg	pt_BR	0	\N	-1	2a63b298-96d5-4ded-a0fc-e7ca3bcff831
460	32	MONOCROMÁTICA	pt_BR	0	\N	-1	2a63b298-96d5-4ded-a0fc-e7ca3bcff831
462	32	Albumina/ Prata	pt_BR	2	\N	-1	2a63b298-96d5-4ded-a0fc-e7ca3bcff831
463	34	Made available in DSpace on 2015-04-16T12:50:59Z (GMT). No. of bitstreams: 1\n001LE002002.jpg: 3615715 bytes, checksum: b6c1bae93f97d633103735e7637503dc (MD5)	en	0	\N	-1	2a63b298-96d5-4ded-a0fc-e7ca3bcff831
464	59	Instituto Moreira Salles	pt_BR	0	\N	-1	2a63b298-96d5-4ded-a0fc-e7ca3bcff831
466	61	Mestres do Séc. XIX	pt_BR	0	\N	-1	2a63b298-96d5-4ded-a0fc-e7ca3bcff831
467	63	Vertical	pt_BR	0	\N	-1	2a63b298-96d5-4ded-a0fc-e7ca3bcff831
469	63	Diurna	pt_BR	2	\N	-1	2a63b298-96d5-4ded-a0fc-e7ca3bcff831
470	63	Flora / Vegetação	pt_BR	3	\N	-1	2a63b298-96d5-4ded-a0fc-e7ca3bcff831
471	63	Externa	pt_BR	4	\N	-1	2a63b298-96d5-4ded-a0fc-e7ca3bcff831
472	70	Palmeira-do-viajante (Ravenala Madagascariense)	pt_BR	0	\N	-1	2a63b298-96d5-4ded-a0fc-e7ca3bcff831
473	72	Fotografia/ Papel	pt_BR	0	\N	-1	2a63b298-96d5-4ded-a0fc-e7ca3bcff831
474	133	Rio de Janeiro	pt_BR	0	\N	-1	2a63b298-96d5-4ded-a0fc-e7ca3bcff831
476	133	RJ	pt_BR	2	\N	-1	2a63b298-96d5-4ded-a0fc-e7ca3bcff831
477	133	Brasil	pt_BR	3	\N	-1	2a63b298-96d5-4ded-a0fc-e7ca3bcff831
479	70	001LE002002.jpg	\N	0	\N	-1	512c54c6-fb9f-4351-a5b8-a15968510dd1
480	70	THUMBNAIL	\N	1	\N	-1	516667ff-c91e-40f5-95b5-c0905f6d9681
481	70	001LE002002.jpg.jpg	\N	0	\N	-1	cefd365e-cc38-49bf-bc47-01718da026b7
482	31	https://hdl.handle.net/20.500.12156.1/2024	\N	0	\N	-1	2a63b298-96d5-4ded-a0fc-e7ca3bcff831
483	17	2019-07-19T13:29:53Z	\N	1	\N	-1	2a63b298-96d5-4ded-a0fc-e7ca3bcff831
484	18	2019-07-19T13:29:53Z	\N	1	\N	-1	2a63b298-96d5-4ded-a0fc-e7ca3bcff831
485	34	Made available in DSpace on 2019-07-19T13:29:53Z (GMT). No. of bitstreams: 2\n001LE002002.jpg: 3615715 bytes, checksum: b6c1bae93f97d633103735e7637503dc (MD5)\n001LE002002.jpg.jpg: 112510 bytes, checksum: edab988457c58e8524da2533ae24d0ff (MD5)	en	1	\N	-1	2a63b298-96d5-4ded-a0fc-e7ca3bcff831
486	32	Generated Thumbnail	\N	0	\N	-1	cefd365e-cc38-49bf-bc47-01718da026b7
494	32	sp:8,7 cm x 5,3 cm     ss:10,2 cm x 6,3 cm	pt_BR	1	\N	-1	23356d3d-62c2-49f3-a1cd-e51531698402
498	59	Solicitar imagem junto ao detentor dos direitos indicado no Copyright	pt_BR	1	\N	-1	23356d3d-62c2-49f3-a1cd-e51531698402
501	63	GILBERTO FERREZ	pt_BR	1	\N	-1	23356d3d-62c2-49f3-a1cd-e51531698402
510	133	Glória	pt_BR	1	\N	-1	23356d3d-62c2-49f3-a1cd-e51531698402
513	70	ORIGINAL	\N	1	\N	-1	9b4bc286-450d-4ddf-aa38-90b226234686
487	7	Klumb, Revert Henrique	pt_BR	0	\N	-1	23356d3d-62c2-49f3-a1cd-e51531698402
488	16	1861 circa	pt_BR	0	\N	-1	23356d3d-62c2-49f3-a1cd-e51531698402
489	17	2015-04-16T12:52:27Z		0	\N	-1	23356d3d-62c2-49f3-a1cd-e51531698402
490	18	2015-04-16T12:52:27Z		0	\N	-1	23356d3d-62c2-49f3-a1cd-e51531698402
491	23	007A5P3F14-13.jpg	pt_BR	0	\N	-1	23356d3d-62c2-49f3-a1cd-e51531698402
493	32	MONOCROMÁTICA	pt_BR	0	\N	-1	23356d3d-62c2-49f3-a1cd-e51531698402
495	32	Albumina/ Prata	pt_BR	2	\N	-1	23356d3d-62c2-49f3-a1cd-e51531698402
496	34	Made available in DSpace on 2015-04-16T12:52:27Z (GMT). No. of bitstreams: 1\n007A5P3F14-13.jpg: 2660821 bytes, checksum: 4dc01f2f65636b1480ceb88b42affdd6 (MD5)	en	0	\N	-1	23356d3d-62c2-49f3-a1cd-e51531698402
497	59	Instituto Moreira Salles	pt_BR	0	\N	-1	23356d3d-62c2-49f3-a1cd-e51531698402
499	61	Gilberto Ferrez	pt_BR	0	\N	-1	23356d3d-62c2-49f3-a1cd-e51531698402
500	63	Bairro da Glória	pt_BR	0	\N	-1	23356d3d-62c2-49f3-a1cd-e51531698402
502	63	Vertical	pt_BR	2	\N	-1	23356d3d-62c2-49f3-a1cd-e51531698402
503	63	Pessoas	pt_BR	3	\N	-1	23356d3d-62c2-49f3-a1cd-e51531698402
504	63	Acidente Geográfico	pt_BR	4	\N	-1	23356d3d-62c2-49f3-a1cd-e51531698402
505	63	Diurna	pt_BR	5	\N	-1	23356d3d-62c2-49f3-a1cd-e51531698402
506	63	Externa	pt_BR	6	\N	-1	23356d3d-62c2-49f3-a1cd-e51531698402
507	70	A Glória, vista do Passeio Público	pt_BR	0	\N	-1	23356d3d-62c2-49f3-a1cd-e51531698402
508	72	Fotografia/ Papel	pt_BR	0	\N	-1	23356d3d-62c2-49f3-a1cd-e51531698402
509	133	Rio de Janeiro	pt_BR	0	\N	-1	23356d3d-62c2-49f3-a1cd-e51531698402
511	133	RJ	pt_BR	2	\N	-1	23356d3d-62c2-49f3-a1cd-e51531698402
512	133	Brasil	pt_BR	3	\N	-1	23356d3d-62c2-49f3-a1cd-e51531698402
514	70	007A5P3F14-13.jpg	\N	0	\N	-1	ef5c27a6-f687-441a-8947-cb07696025e3
515	70	THUMBNAIL	\N	1	\N	-1	e2c4c22c-eb00-425a-9cc1-b9240fd18311
516	70	007A5P3F14-13.jpg.jpg	\N	0	\N	-1	6d1d212d-f94a-4d27-942f-b3a6f27bf865
517	31	https://hdl.handle.net/20.500.12156.1/2245	\N	0	\N	-1	23356d3d-62c2-49f3-a1cd-e51531698402
518	17	2019-07-19T13:29:53Z	\N	1	\N	-1	23356d3d-62c2-49f3-a1cd-e51531698402
519	18	2019-07-19T13:29:53Z	\N	1	\N	-1	23356d3d-62c2-49f3-a1cd-e51531698402
520	34	Made available in DSpace on 2019-07-19T13:29:53Z (GMT). No. of bitstreams: 2\n007A5P3F14-13.jpg: 2660821 bytes, checksum: 4dc01f2f65636b1480ceb88b42affdd6 (MD5)\n007A5P3F14-13.jpg.jpg: 67852 bytes, checksum: c86493a26e4a22e4d3509da116f26ca9 (MD5)	en	1	\N	-1	23356d3d-62c2-49f3-a1cd-e51531698402
521	32	Generated Thumbnail	\N	0	\N	-1	6d1d212d-f94a-4d27-942f-b3a6f27bf865
529	32	Gelatina/ Prata	pt_BR	1	\N	-1	6a7ea32d-9b1f-46c2-a002-75292eef9a8f
532	59	Solicitar imagem junto ao detentor dos direitos indicado no Copyright	pt_BR	1	\N	-1	6a7ea32d-9b1f-46c2-a002-75292eef9a8f
535	63	Aspectos Urbanos	pt_BR	1	\N	-1	6a7ea32d-9b1f-46c2-a002-75292eef9a8f
549	133	Avenida Central (atual Av. Rio Branco)	pt_BR	1	\N	-1	6a7ea32d-9b1f-46c2-a002-75292eef9a8f
552	70	ORIGINAL	\N	1	\N	-1	65710ee6-0ba1-41d7-baf4-d488222918a7
522	7	Ferrez, Marc	pt_BR	0	\N	-1	6a7ea32d-9b1f-46c2-a002-75292eef9a8f
523	16	1910 circa	pt_BR	0	\N	-1	6a7ea32d-9b1f-46c2-a002-75292eef9a8f
524	17	2015-04-16T12:54:13Z		0	\N	-1	6a7ea32d-9b1f-46c2-a002-75292eef9a8f
525	18	2015-04-16T12:54:13Z		0	\N	-1	6a7ea32d-9b1f-46c2-a002-75292eef9a8f
526	23	007NGBMF2430e1824cx98-14.jpg	pt_BR	0	\N	-1	6a7ea32d-9b1f-46c2-a002-75292eef9a8f
528	32	MONOCROMÁTICA / SEPIA	pt_BR	0	\N	-1	6a7ea32d-9b1f-46c2-a002-75292eef9a8f
530	34	Made available in DSpace on 2015-04-16T12:54:13Z (GMT). No. of bitstreams: 1\r\n007NGBMF2430e1824cx98-14.jpg: 5557116 bytes, checksum: b35ec8c0e6275f0c67317ae8968e085b (MD5)	en	0	\N	-1	6a7ea32d-9b1f-46c2-a002-75292eef9a8f
531	59	Instituto Moreira	pt_BR	0	\N	-1	6a7ea32d-9b1f-46c2-a002-75292eef9a8f
533	61	Gilberto Ferrez	pt_BR	0	\N	-1	6a7ea32d-9b1f-46c2-a002-75292eef9a8f
534	63	Paisagismo	pt_BR	0	\N	-1	6a7ea32d-9b1f-46c2-a002-75292eef9a8f
536	63	Avenida Central (Rio de Janeiro)	pt_BR	2	\N	-1	6a7ea32d-9b1f-46c2-a002-75292eef9a8f
537	63	Avenida Rio Branco (Rio de Janeiro)	pt_BR	3	\N	-1	6a7ea32d-9b1f-46c2-a002-75292eef9a8f
538	63	Centro do Rio de Janeiro	pt_BR	4	\N	-1	6a7ea32d-9b1f-46c2-a002-75292eef9a8f
539	63	GILBERTO FERREZ	pt_BR	5	\N	-1	6a7ea32d-9b1f-46c2-a002-75292eef9a8f
540	63	Teatro Municipal do Rio de Janeiro	pt_BR	6	\N	-1	6a7ea32d-9b1f-46c2-a002-75292eef9a8f
541	63	Arquitetura	pt_BR	7	\N	-1	6a7ea32d-9b1f-46c2-a002-75292eef9a8f
542	63	Horizontal	pt_BR	8	\N	-1	6a7ea32d-9b1f-46c2-a002-75292eef9a8f
543	63	Diurna	pt_BR	9	\N	-1	6a7ea32d-9b1f-46c2-a002-75292eef9a8f
544	63	Flora / Vegetação	pt_BR	10	\N	-1	6a7ea32d-9b1f-46c2-a002-75292eef9a8f
545	63	Externa	pt_BR	11	\N	-1	6a7ea32d-9b1f-46c2-a002-75292eef9a8f
546	70	Teatro Municipal	pt_BR	0	\N	-1	6a7ea32d-9b1f-46c2-a002-75292eef9a8f
547	72	Negativo/ Vidro	pt_BR	0	\N	-1	6a7ea32d-9b1f-46c2-a002-75292eef9a8f
548	133	Rio de Janeiro	pt_BR	0	\N	-1	6a7ea32d-9b1f-46c2-a002-75292eef9a8f
550	133	RJ	pt_BR	2	\N	-1	6a7ea32d-9b1f-46c2-a002-75292eef9a8f
551	133	Brasil	pt_BR	3	\N	-1	6a7ea32d-9b1f-46c2-a002-75292eef9a8f
553	70	007NGBMF2430e1824cx98-14.jpg	\N	0	\N	-1	7a7c4e68-9f8e-4b25-88aa-b7642e53c76b
554	70	THUMBNAIL	\N	1	\N	-1	3a6f9fd1-ada9-4a1f-a5b9-f4ee408c36d0
555	70	007NGBMF2430e1824cx98-14.jpg.jpg	\N	0	\N	-1	16c9fb36-2b62-4e88-b7f1-264c227db582
556	31	https://hdl.handle.net/20.500.12156.1/2586	\N	0	\N	-1	6a7ea32d-9b1f-46c2-a002-75292eef9a8f
557	17	2019-07-19T13:29:54Z	\N	1	\N	-1	6a7ea32d-9b1f-46c2-a002-75292eef9a8f
558	18	2019-07-19T13:29:54Z	\N	1	\N	-1	6a7ea32d-9b1f-46c2-a002-75292eef9a8f
559	34	Made available in DSpace on 2019-07-19T13:29:54Z (GMT). No. of bitstreams: 2\n007NGBMF2430e1824cx98-14.jpg: 5557116 bytes, checksum: b35ec8c0e6275f0c67317ae8968e085b (MD5)\n007NGBMF2430e1824cx98-14.jpg.jpg: 132550 bytes, checksum: 004bd4499ef052353d5984c33eb42252 (MD5)	en	1	\N	-1	6a7ea32d-9b1f-46c2-a002-75292eef9a8f
560	32	Generated Thumbnail	\N	0	\N	-1	16c9fb36-2b62-4e88-b7f1-264c227db582
568	32	i/sp: 24,0 x 30,0 cm	pt_BR	1	\N	-1	e34bee2e-ff66-4fda-8ef0-a70a9cc27139
572	59	Solicitar imagem junto ao detentor dos direitos indicado no Copyright	pt_BR	1	\N	-1	e34bee2e-ff66-4fda-8ef0-a70a9cc27139
575	63	Cena de rua	pt_BR	1	\N	-1	e34bee2e-ff66-4fda-8ef0-a70a9cc27139
587	133	Centro	pt_BR	1	\N	-1	e34bee2e-ff66-4fda-8ef0-a70a9cc27139
590	70	ORIGINAL	\N	1	\N	-1	437a093f-a0eb-4947-9366-12e7cea4f579
561	7	Ferrez, Marc	pt_BR	0	\N	-1	e34bee2e-ff66-4fda-8ef0-a70a9cc27139
562	16	1887 circa	pt_BR	0	\N	-1	e34bee2e-ff66-4fda-8ef0-a70a9cc27139
563	17	2015-04-16T12:51:45Z		0	\N	-1	e34bee2e-ff66-4fda-8ef0-a70a9cc27139
564	18	2015-04-16T12:51:45Z		0	\N	-1	e34bee2e-ff66-4fda-8ef0-a70a9cc27139
565	23	0072430CX097-11.jpg	pt_BR	0	\N	-1	e34bee2e-ff66-4fda-8ef0-a70a9cc27139
567	32	MONOCROMÁTICA	pt_BR	0	\N	-1	e34bee2e-ff66-4fda-8ef0-a70a9cc27139
569	32	Gelatina/ Prata	pt_BR	2	\N	-1	e34bee2e-ff66-4fda-8ef0-a70a9cc27139
570	34	Made available in DSpace on 2015-04-16T12:51:45Z (GMT). No. of bitstreams: 1\r\n0072430CX097-11.jpg: 9739719 bytes, checksum: 7c57e98f91b2f99a95d687df953d7e2b (MD5)	en	0	\N	-1	e34bee2e-ff66-4fda-8ef0-a70a9cc27139
571	59	Instituto Moreira Salles	pt_BR	0	\N	-1	e34bee2e-ff66-4fda-8ef0-a70a9cc27139
573	61	Gilberto Ferrez	pt_BR	0	\N	-1	e34bee2e-ff66-4fda-8ef0-a70a9cc27139
574	63	Aspectos Urbanos	pt_BR	0	\N	-1	e34bee2e-ff66-4fda-8ef0-a70a9cc27139
576	63	Real Gabinete Português de Leitura	pt_BR	2	\N	-1	e34bee2e-ff66-4fda-8ef0-a70a9cc27139
577	63	GILBERTO FERREZ	pt_BR	3	\N	-1	e34bee2e-ff66-4fda-8ef0-a70a9cc27139
578	63	Rua Luís de Camões	pt_BR	4	\N	-1	e34bee2e-ff66-4fda-8ef0-a70a9cc27139
579	63	Vertical	pt_BR	5	\N	-1	e34bee2e-ff66-4fda-8ef0-a70a9cc27139
580	63	Escola Politécnica do Rio de Janeiro	pt_BR	6	\N	-1	e34bee2e-ff66-4fda-8ef0-a70a9cc27139
581	63	Arquitetura	pt_BR	7	\N	-1	e34bee2e-ff66-4fda-8ef0-a70a9cc27139
582	63	Diurna	pt_BR	8	\N	-1	e34bee2e-ff66-4fda-8ef0-a70a9cc27139
583	63	Externa	pt_BR	9	\N	-1	e34bee2e-ff66-4fda-8ef0-a70a9cc27139
584	70	Real Gabinete Português de Leitura, na rua Luís de Camões. À direita os fundos da Escola Politécnica, atual IFCS/UFRJ	pt_BR	0	\N	-1	e34bee2e-ff66-4fda-8ef0-a70a9cc27139
585	72	Negativo/ Vidro	pt_BR	0	\N	-1	e34bee2e-ff66-4fda-8ef0-a70a9cc27139
586	133	Rio de Janeiro	pt_BR	0	\N	-1	e34bee2e-ff66-4fda-8ef0-a70a9cc27139
588	133	RJ	pt_BR	2	\N	-1	e34bee2e-ff66-4fda-8ef0-a70a9cc27139
589	133	Brasil	pt_BR	3	\N	-1	e34bee2e-ff66-4fda-8ef0-a70a9cc27139
591	70	0072430CX097-11.jpg	\N	0	\N	-1	1b96bd99-3e47-4f72-8a9c-41e3c8281bbf
592	70	THUMBNAIL	\N	1	\N	-1	f5322472-6bb0-4db5-b7c6-ff39f0f389bf
593	70	0072430CX097-11.jpg.jpg	\N	0	\N	-1	10bb7ba1-0221-444d-af12-4ef6ca1affc3
594	31	https://hdl.handle.net/20.500.12156.1/2139	\N	0	\N	-1	e34bee2e-ff66-4fda-8ef0-a70a9cc27139
595	17	2019-07-19T13:29:56Z	\N	1	\N	-1	e34bee2e-ff66-4fda-8ef0-a70a9cc27139
596	18	2019-07-19T13:29:56Z	\N	1	\N	-1	e34bee2e-ff66-4fda-8ef0-a70a9cc27139
597	34	Made available in DSpace on 2019-07-19T13:29:56Z (GMT). No. of bitstreams: 2\n0072430CX097-11.jpg: 9739719 bytes, checksum: 7c57e98f91b2f99a95d687df953d7e2b (MD5)\n0072430CX097-11.jpg.jpg: 121005 bytes, checksum: bd1a4f71ce45aa383dad2c1c2c5b778b (MD5)	en	1	\N	-1	e34bee2e-ff66-4fda-8ef0-a70a9cc27139
598	32	Generated Thumbnail	\N	0	\N	-1	10bb7ba1-0221-444d-af12-4ef6ca1affc3
606	32	i: 22,3 x 16,2 cm	pt_BR	1	\N	-1	5cc3c183-a750-4b2a-8d8d-d4e4fdcc31d7
610	59	Solicitar imagem junto ao detentor dos direitos indicado no Copyright	pt_BR	1	\N	-1	5cc3c183-a750-4b2a-8d8d-d4e4fdcc31d7
613	63	Vertical	pt_BR	1	\N	-1	5cc3c183-a750-4b2a-8d8d-d4e4fdcc31d7
620	133	Rua Jardim Botânico	pt_BR	1	\N	-1	5cc3c183-a750-4b2a-8d8d-d4e4fdcc31d7
623	70	ORIGINAL	\N	1	\N	-1	06fbd362-9e07-4867-977b-1971ef7e1812
599	7	Ferrez, Marc	pt_BR	0	\N	-1	5cc3c183-a750-4b2a-8d8d-d4e4fdcc31d7
600	16	1890 circa	pt_BR	0	\N	-1	5cc3c183-a750-4b2a-8d8d-d4e4fdcc31d7
601	17	2015-04-16T12:54:06Z		0	\N	-1	5cc3c183-a750-4b2a-8d8d-d4e4fdcc31d7
602	18	2015-04-16T12:54:06Z		0	\N	-1	5cc3c183-a750-4b2a-8d8d-d4e4fdcc31d7
603	23	007Marc Ferrez15.jpg	pt_BR	0	\N	-1	5cc3c183-a750-4b2a-8d8d-d4e4fdcc31d7
605	32	MONOCROMÁTICA	pt_BR	0	\N	-1	5cc3c183-a750-4b2a-8d8d-d4e4fdcc31d7
607	32	Albumina/ Prata	pt_BR	2	\N	-1	5cc3c183-a750-4b2a-8d8d-d4e4fdcc31d7
608	34	Made available in DSpace on 2015-04-16T12:54:06Z (GMT). No. of bitstreams: 1\n007Marc Ferrez15.jpg: 3089400 bytes, checksum: 7745cd32ccc1540bc62a2d5c92796754 (MD5)	en	0	\N	-1	5cc3c183-a750-4b2a-8d8d-d4e4fdcc31d7
609	59	Instituto Moreira Salles	pt_BR	0	\N	-1	5cc3c183-a750-4b2a-8d8d-d4e4fdcc31d7
611	61	Gilberto Ferrez	pt_BR	0	\N	-1	5cc3c183-a750-4b2a-8d8d-d4e4fdcc31d7
612	63	Jardim Botânico	pt_BR	0	\N	-1	5cc3c183-a750-4b2a-8d8d-d4e4fdcc31d7
614	63	Diurna	pt_BR	2	\N	-1	5cc3c183-a750-4b2a-8d8d-d4e4fdcc31d7
615	63	GILBERTO FERREZ	pt_BR	3	\N	-1	5cc3c183-a750-4b2a-8d8d-d4e4fdcc31d7
616	63	Externa	pt_BR	4	\N	-1	5cc3c183-a750-4b2a-8d8d-d4e4fdcc31d7
617	70	Jardim Botânico, aléia das palmeiras	pt_BR	0	\N	-1	5cc3c183-a750-4b2a-8d8d-d4e4fdcc31d7
618	72	Fotografia	pt_BR	0	\N	-1	5cc3c183-a750-4b2a-8d8d-d4e4fdcc31d7
619	133	Rio de Janeiro	pt_BR	0	\N	-1	5cc3c183-a750-4b2a-8d8d-d4e4fdcc31d7
621	133	RJ	pt_BR	2	\N	-1	5cc3c183-a750-4b2a-8d8d-d4e4fdcc31d7
622	133	Brasil	pt_BR	3	\N	-1	5cc3c183-a750-4b2a-8d8d-d4e4fdcc31d7
624	70	007Marc Ferrez15.jpg	\N	0	\N	-1	acdc902a-8ef6-42bb-b3e0-0fcdf857d7bd
625	70	THUMBNAIL	\N	1	\N	-1	a2621d19-9ee1-4e91-b431-9c56ff0a9a95
626	70	007Marc Ferrez15.jpg.jpg	\N	0	\N	-1	b3b12b38-695a-402c-b1e8-3f42e26fa755
627	31	https://hdl.handle.net/20.500.12156.1/2555	\N	0	\N	-1	5cc3c183-a750-4b2a-8d8d-d4e4fdcc31d7
628	17	2019-07-19T13:29:57Z	\N	1	\N	-1	5cc3c183-a750-4b2a-8d8d-d4e4fdcc31d7
629	18	2019-07-19T13:29:57Z	\N	1	\N	-1	5cc3c183-a750-4b2a-8d8d-d4e4fdcc31d7
630	34	Made available in DSpace on 2019-07-19T13:29:57Z (GMT). No. of bitstreams: 2\n007Marc Ferrez15.jpg: 3089400 bytes, checksum: 7745cd32ccc1540bc62a2d5c92796754 (MD5)\n007Marc Ferrez15.jpg.jpg: 77750 bytes, checksum: 17f4bc9425e3ca8845f755bd2517e074 (MD5)	en	1	\N	-1	5cc3c183-a750-4b2a-8d8d-d4e4fdcc31d7
631	32	Generated Thumbnail	\N	0	\N	-1	b3b12b38-695a-402c-b1e8-3f42e26fa755
639	32	sp: 18,0 x 24,0 cm	pt_BR	1	\N	-1	987f4af4-d57e-4f67-b3d3-0513b13bf9f2
643	59	Solicitar imagem junto ao detentor dos direitos indicado no Copyright	pt_BR	1	\N	-1	987f4af4-d57e-4f67-b3d3-0513b13bf9f2
646	63	Cena de rua	pt_BR	1	\N	-1	987f4af4-d57e-4f67-b3d3-0513b13bf9f2
657	133	RJ	pt_BR	1	\N	-1	987f4af4-d57e-4f67-b3d3-0513b13bf9f2
659	70	ORIGINAL	\N	1	\N	-1	06956b32-551b-4839-8298-46656be0928e
632	7	Ferrez, Marc	pt_BR	0	\N	-1	987f4af4-d57e-4f67-b3d3-0513b13bf9f2
633	16	1890 circa	pt_BR	0	\N	-1	987f4af4-d57e-4f67-b3d3-0513b13bf9f2
634	17	2016-10-18T19:05:34Z		0	\N	-1	987f4af4-d57e-4f67-b3d3-0513b13bf9f2
635	18	2016-10-18T19:05:34Z		0	\N	-1	987f4af4-d57e-4f67-b3d3-0513b13bf9f2
636	23	0071824cx019-08.JPG	pt_BR	0	\N	-1	987f4af4-d57e-4f67-b3d3-0513b13bf9f2
638	32	MONOCROMÁTICA	pt_BR	0	\N	-1	987f4af4-d57e-4f67-b3d3-0513b13bf9f2
640	32	Gelatina/ Prata	pt_BR	2	\N	-1	987f4af4-d57e-4f67-b3d3-0513b13bf9f2
641	34	Made available in DSpace on 2016-10-18T19:05:34Z (GMT). No. of bitstreams: 1\r\n0071824cx019-08.JPG: 7713749 bytes, checksum: bde294086bd2cfc39e148cdc78937963 (MD5)	en	0	\N	-1	987f4af4-d57e-4f67-b3d3-0513b13bf9f2
642	59	Instituto Moreira Salles	pt_BR	0	\N	-1	987f4af4-d57e-4f67-b3d3-0513b13bf9f2
644	61	Coleção Gilberto Ferrez	pt_BR	0	\N	-1	987f4af4-d57e-4f67-b3d3-0513b13bf9f2
645	63	Rua Primeiro de Março	pt_BR	0	\N	-1	987f4af4-d57e-4f67-b3d3-0513b13bf9f2
647	63	Panorama	pt_BR	2	\N	-1	987f4af4-d57e-4f67-b3d3-0513b13bf9f2
648	63	Rua Direita (atual Primeiro de Março)	pt_BR	3	\N	-1	987f4af4-d57e-4f67-b3d3-0513b13bf9f2
649	63	Externa	pt_BR	4	\N	-1	987f4af4-d57e-4f67-b3d3-0513b13bf9f2
650	63	Negativos de Vidro	pt_BR	5	\N	-1	987f4af4-d57e-4f67-b3d3-0513b13bf9f2
651	63	Trabalho	pt_BR	6	\N	-1	987f4af4-d57e-4f67-b3d3-0513b13bf9f2
652	63	Horizontal	pt_BR	7	\N	-1	987f4af4-d57e-4f67-b3d3-0513b13bf9f2
653	63	Diurna	pt_BR	8	\N	-1	987f4af4-d57e-4f67-b3d3-0513b13bf9f2
654	70	Rua Primeiro de Março	pt_BR	0	\N	-1	987f4af4-d57e-4f67-b3d3-0513b13bf9f2
655	72	Negativo/ Vidro	pt_BR	0	\N	-1	987f4af4-d57e-4f67-b3d3-0513b13bf9f2
656	133	Rio de Janeiro	pt_BR	0	\N	-1	987f4af4-d57e-4f67-b3d3-0513b13bf9f2
658	133	Brasil	pt_BR	2	\N	-1	987f4af4-d57e-4f67-b3d3-0513b13bf9f2
660	70	0071824cx019-08.JPG	\N	0	\N	-1	d2ada78c-e4b4-44b6-ae6c-de2f19d7a6ed
661	70	THUMBNAIL	\N	1	\N	-1	317d384a-8bd7-443f-ae59-9b110bd89412
662	70	0071824cx019-08.JPG.jpg	\N	0	\N	-1	45d71b80-aa07-468e-b508-ab087c394aeb
663	31	https://hdl.handle.net/20.500.12156.1/4755	\N	0	\N	-1	987f4af4-d57e-4f67-b3d3-0513b13bf9f2
664	17	2019-07-19T13:29:58Z	\N	1	\N	-1	987f4af4-d57e-4f67-b3d3-0513b13bf9f2
665	18	2019-07-19T13:29:58Z	\N	1	\N	-1	987f4af4-d57e-4f67-b3d3-0513b13bf9f2
666	34	Made available in DSpace on 2019-07-19T13:29:58Z (GMT). No. of bitstreams: 2\n0071824cx019-08.JPG: 7713749 bytes, checksum: bde294086bd2cfc39e148cdc78937963 (MD5)\n0071824cx019-08.JPG.jpg: 161158 bytes, checksum: 07f01fc7220f760f50fde746af013fa6 (MD5)	en	1	\N	-1	987f4af4-d57e-4f67-b3d3-0513b13bf9f2
667	32	Generated Thumbnail	\N	0	\N	-1	45d71b80-aa07-468e-b508-ab087c394aeb
675	32	i: 15,5 x 34,5 cm; sp: 17,1 x 34,6 cm; ss: 26,8 x 43,5 cm	pt_BR	1	\N	-1	b0e86f74-1ff4-495d-827b-0d8b4f1c9d4b
679	59	Solicitar imagem junto ao detentor dos direitos indicado no Copyright	pt_BR	1	\N	-1	b0e86f74-1ff4-495d-827b-0d8b4f1c9d4b
682	63	Panorama	pt_BR	1	\N	-1	b0e86f74-1ff4-495d-827b-0d8b4f1c9d4b
692	133	RJ	pt_BR	1	\N	-1	b0e86f74-1ff4-495d-827b-0d8b4f1c9d4b
694	70	ORIGINAL	\N	1	\N	-1	f9cb7f87-a781-4b0f-8a9a-7eb5bc501b65
668	7	Ferrez, Marc	pt_BR	0	\N	-1	b0e86f74-1ff4-495d-827b-0d8b4f1c9d4b
669	16	1890 circa	pt_BR	0	\N	-1	b0e86f74-1ff4-495d-827b-0d8b4f1c9d4b
670	17	2015-04-16T12:50:09Z		0	\N	-1	b0e86f74-1ff4-495d-827b-0d8b4f1c9d4b
671	18	2015-04-16T12:50:09Z		0	\N	-1	b0e86f74-1ff4-495d-827b-0d8b4f1c9d4b
672	23	001AMF015011.jpg	pt_BR	0	\N	-1	b0e86f74-1ff4-495d-827b-0d8b4f1c9d4b
674	32	MONOCROMÁTICA	pt_BR	0	\N	-1	b0e86f74-1ff4-495d-827b-0d8b4f1c9d4b
676	32	Albumina/ Prata	pt_BR	2	\N	-1	b0e86f74-1ff4-495d-827b-0d8b4f1c9d4b
677	34	Made available in DSpace on 2015-04-16T12:50:09Z (GMT). No. of bitstreams: 1\r\n001AMF015011.jpg: 10002210 bytes, checksum: 4514265c27ded188f844cee8a42130be (MD5)	en	0	\N	-1	b0e86f74-1ff4-495d-827b-0d8b4f1c9d4b
678	59	Instituto Moreira Salles	pt_BR	0	\N	-1	b0e86f74-1ff4-495d-827b-0d8b4f1c9d4b
680	61	Mestres do Séc. XIX	pt_BR	0	\N	-1	b0e86f74-1ff4-495d-827b-0d8b4f1c9d4b
681	63	Aspectos Urbanos	pt_BR	0	\N	-1	b0e86f74-1ff4-495d-827b-0d8b4f1c9d4b
683	63	Álbum Panoramas do Rio de Janeiro	pt_BR	2	\N	-1	b0e86f74-1ff4-495d-827b-0d8b4f1c9d4b
684	63	Horizontal	pt_BR	3	\N	-1	b0e86f74-1ff4-495d-827b-0d8b4f1c9d4b
685	63	Acidente Geográfico	pt_BR	4	\N	-1	b0e86f74-1ff4-495d-827b-0d8b4f1c9d4b
686	63	Diurna	pt_BR	5	\N	-1	b0e86f74-1ff4-495d-827b-0d8b4f1c9d4b
687	63	Externa	pt_BR	6	\N	-1	b0e86f74-1ff4-495d-827b-0d8b4f1c9d4b
688	63	Paisagem	pt_BR	7	\N	-1	b0e86f74-1ff4-495d-827b-0d8b4f1c9d4b
689	70	Álbum Panoramas do Rio de Janeiro - Praia de Santa Luzia	pt_BR	0	\N	-1	b0e86f74-1ff4-495d-827b-0d8b4f1c9d4b
690	72	Fotografia/ Papel	pt_BR	0	\N	-1	b0e86f74-1ff4-495d-827b-0d8b4f1c9d4b
691	133	Rio de Janeiro	pt_BR	0	\N	-1	b0e86f74-1ff4-495d-827b-0d8b4f1c9d4b
693	133	Brasil	pt_BR	2	\N	-1	b0e86f74-1ff4-495d-827b-0d8b4f1c9d4b
695	70	001AMF015011.jpg	\N	0	\N	-1	ef28e49e-8b42-49b5-8154-c1e13b376618
696	70	THUMBNAIL	\N	1	\N	-1	435a868d-93c3-41ec-b2d4-8ba1ff771e1f
697	70	001AMF015011.jpg.jpg	\N	0	\N	-1	95589053-8ff6-4088-a327-85e300875f32
698	31	https://hdl.handle.net/20.500.12156.1/1876	\N	0	\N	-1	b0e86f74-1ff4-495d-827b-0d8b4f1c9d4b
699	17	2019-07-19T13:30:00Z	\N	1	\N	-1	b0e86f74-1ff4-495d-827b-0d8b4f1c9d4b
700	18	2019-07-19T13:30:00Z	\N	1	\N	-1	b0e86f74-1ff4-495d-827b-0d8b4f1c9d4b
701	34	Made available in DSpace on 2019-07-19T13:30:00Z (GMT). No. of bitstreams: 2\n001AMF015011.jpg: 10002210 bytes, checksum: 4514265c27ded188f844cee8a42130be (MD5)\n001AMF015011.jpg.jpg: 111875 bytes, checksum: 17c73481c7a09782fecf8e0d7af12444 (MD5)	en	1	\N	-1	b0e86f74-1ff4-495d-827b-0d8b4f1c9d4b
702	32	Generated Thumbnail	\N	0	\N	-1	95589053-8ff6-4088-a327-85e300875f32
710	32	i: 18,0 x 24,0 cm	pt_BR	1	\N	-1	68370f47-347b-40f5-a0bd-4cc2c6119c8e
714	59	Solicitar imagem junto ao detentor dos direitos indicado no Copyright	pt_BR	1	\N	-1	68370f47-347b-40f5-a0bd-4cc2c6119c8e
717	63	Panorama	pt_BR	1	\N	-1	68370f47-347b-40f5-a0bd-4cc2c6119c8e
726	133	Floresta da Tijuca	pt_BR	1	\N	-1	68370f47-347b-40f5-a0bd-4cc2c6119c8e
729	70	ORIGINAL	\N	1	\N	-1	8d8ceac0-5b32-45c2-a928-32ebf9070558
703	7	Malta, Augusto	pt_BR	0	\N	-1	68370f47-347b-40f5-a0bd-4cc2c6119c8e
704	16	1906	pt_BR	0	\N	-1	68370f47-347b-40f5-a0bd-4cc2c6119c8e
705	17	2015-04-16T12:56:00Z		0	\N	-1	68370f47-347b-40f5-a0bd-4cc2c6119c8e
706	18	2015-04-16T12:56:00Z		0	\N	-1	68370f47-347b-40f5-a0bd-4cc2c6119c8e
707	23	014AM012048.jpg	pt_BR	0	\N	-1	68370f47-347b-40f5-a0bd-4cc2c6119c8e
709	32	P&B	pt_BR	0	\N	-1	68370f47-347b-40f5-a0bd-4cc2c6119c8e
711	32	Gelatina/ Prata	pt_BR	2	\N	-1	68370f47-347b-40f5-a0bd-4cc2c6119c8e
712	34	Made available in DSpace on 2015-04-16T12:56:00Z (GMT). No. of bitstreams: 1\n014AM012048.jpg: 24469509 bytes, checksum: dd1e9ea7715ed0339927c60d3df8e720 (MD5)	en	0	\N	-1	68370f47-347b-40f5-a0bd-4cc2c6119c8e
713	59	Instituto Moreira Salles	pt_BR	0	\N	-1	68370f47-347b-40f5-a0bd-4cc2c6119c8e
715	61	Pedro Corrêa do Lago	pt_BR	0	\N	-1	68370f47-347b-40f5-a0bd-4cc2c6119c8e
716	63	Vista Chinesa	pt_BR	0	\N	-1	68370f47-347b-40f5-a0bd-4cc2c6119c8e
718	63	PEDRO CORRÊA do LAGO	pt_BR	2	\N	-1	68370f47-347b-40f5-a0bd-4cc2c6119c8e
719	63	Floresta da Tijuca	pt_BR	3	\N	-1	68370f47-347b-40f5-a0bd-4cc2c6119c8e
720	63	Diurna	pt_BR	4	\N	-1	68370f47-347b-40f5-a0bd-4cc2c6119c8e
721	63	Paisagem natural	pt_BR	5	\N	-1	68370f47-347b-40f5-a0bd-4cc2c6119c8e
722	63	Externa	pt_BR	6	\N	-1	68370f47-347b-40f5-a0bd-4cc2c6119c8e
723	70	Vista Chinesa	pt_BR	0	\N	-1	68370f47-347b-40f5-a0bd-4cc2c6119c8e
724	72	Fotografia/ Papel	pt_BR	0	\N	-1	68370f47-347b-40f5-a0bd-4cc2c6119c8e
725	133	Rio de Janeiro	pt_BR	0	\N	-1	68370f47-347b-40f5-a0bd-4cc2c6119c8e
727	133	RJ	pt_BR	2	\N	-1	68370f47-347b-40f5-a0bd-4cc2c6119c8e
728	133	Brasil	pt_BR	3	\N	-1	68370f47-347b-40f5-a0bd-4cc2c6119c8e
730	70	014AM012048.jpg	\N	0	\N	-1	98b4567c-f60d-48a8-b40b-aa109b896617
731	70	THUMBNAIL	\N	1	\N	-1	0fd73a3a-ff0d-429c-a24e-4bc9443a54b4
732	70	014AM012048.jpg.jpg	\N	0	\N	-1	785ff8cd-eaf7-40c4-8409-9a80f5a01c6d
733	31	https://hdl.handle.net/20.500.12156.1/2777	\N	0	\N	-1	68370f47-347b-40f5-a0bd-4cc2c6119c8e
734	17	2019-07-19T13:30:03Z	\N	1	\N	-1	68370f47-347b-40f5-a0bd-4cc2c6119c8e
735	18	2019-07-19T13:30:03Z	\N	1	\N	-1	68370f47-347b-40f5-a0bd-4cc2c6119c8e
736	34	Made available in DSpace on 2019-07-19T13:30:03Z (GMT). No. of bitstreams: 2\n014AM012048.jpg: 24469509 bytes, checksum: dd1e9ea7715ed0339927c60d3df8e720 (MD5)\n014AM012048.jpg.jpg: 129041 bytes, checksum: 66f3fb21f00274bc95e5560552ee22be (MD5)	en	1	\N	-1	68370f47-347b-40f5-a0bd-4cc2c6119c8e
737	32	Generated Thumbnail	\N	0	\N	-1	785ff8cd-eaf7-40c4-8409-9a80f5a01c6d
745	32	i/sp:21,0 cm x 29,3 cm	pt_BR	1	\N	-1	65396002-d1d3-4237-83ee-52d2dc506bd5
749	59	Solicitar imagem junto ao detentor dos direitos indicado no Copyright	pt_BR	1	\N	-1	65396002-d1d3-4237-83ee-52d2dc506bd5
752	63	Largo da Carioca	pt_BR	1	\N	-1	65396002-d1d3-4237-83ee-52d2dc506bd5
762	133	Centro	pt_BR	1	\N	-1	65396002-d1d3-4237-83ee-52d2dc506bd5
765	70	ORIGINAL	\N	1	\N	-1	78e9be50-f651-4538-8319-a6e2ca4c2d91
738	7	Malta, Augusto	pt_BR	0	\N	-1	65396002-d1d3-4237-83ee-52d2dc506bd5
739	16	1907/01/08	pt_BR	0	\N	-1	65396002-d1d3-4237-83ee-52d2dc506bd5
740	17	2015-04-16T12:53:25Z		0	\N	-1	65396002-d1d3-4237-83ee-52d2dc506bd5
741	18	2015-04-16T12:53:25Z		0	\N	-1	65396002-d1d3-4237-83ee-52d2dc506bd5
742	23	007A5P4F2-02.jpg	pt_BR	0	\N	-1	65396002-d1d3-4237-83ee-52d2dc506bd5
744	32	P&B	pt_BR	0	\N	-1	65396002-d1d3-4237-83ee-52d2dc506bd5
746	32	Albumina/ Prata	pt_BR	2	\N	-1	65396002-d1d3-4237-83ee-52d2dc506bd5
747	34	Made available in DSpace on 2015-04-16T12:53:25Z (GMT). No. of bitstreams: 1\n007A5P4F2-02.jpg: 5941020 bytes, checksum: f9a87252f065371cc909c6566258048d (MD5)	en	0	\N	-1	65396002-d1d3-4237-83ee-52d2dc506bd5
748	59	Instituto Moreira Salles	pt_BR	0	\N	-1	65396002-d1d3-4237-83ee-52d2dc506bd5
750	61	Gilberto Ferrez	pt_BR	0	\N	-1	65396002-d1d3-4237-83ee-52d2dc506bd5
751	63	Cena de rua	pt_BR	0	\N	-1	65396002-d1d3-4237-83ee-52d2dc506bd5
753	63	GILBERTO FERREZ	pt_BR	2	\N	-1	65396002-d1d3-4237-83ee-52d2dc506bd5
754	63	Pessoas	pt_BR	3	\N	-1	65396002-d1d3-4237-83ee-52d2dc506bd5
755	63	Horizontal	pt_BR	4	\N	-1	65396002-d1d3-4237-83ee-52d2dc506bd5
756	63	Arquitetura	pt_BR	5	\N	-1	65396002-d1d3-4237-83ee-52d2dc506bd5
757	63	Diurna	pt_BR	6	\N	-1	65396002-d1d3-4237-83ee-52d2dc506bd5
758	63	Externa	pt_BR	7	\N	-1	65396002-d1d3-4237-83ee-52d2dc506bd5
759	70	Largo da Carioca	pt_BR	0	\N	-1	65396002-d1d3-4237-83ee-52d2dc506bd5
760	72	Fotografia/ Papel	pt_BR	0	\N	-1	65396002-d1d3-4237-83ee-52d2dc506bd5
761	133	Rio de Janeiro	pt_BR	0	\N	-1	65396002-d1d3-4237-83ee-52d2dc506bd5
763	133	RJ	pt_BR	2	\N	-1	65396002-d1d3-4237-83ee-52d2dc506bd5
764	133	Brasil	pt_BR	3	\N	-1	65396002-d1d3-4237-83ee-52d2dc506bd5
766	70	007A5P4F2-02.jpg	\N	0	\N	-1	7df28185-e119-41ae-a6f0-8040cae712c8
767	70	THUMBNAIL	\N	1	\N	-1	0bb280a7-63a0-459f-8e4b-c5473e9337ab
768	70	007A5P4F2-02.jpg.jpg	\N	0	\N	-1	8b3691d8-dde6-4512-bdd2-92f5eaeb47fa
769	31	https://hdl.handle.net/20.500.12156.1/2443	\N	0	\N	-1	65396002-d1d3-4237-83ee-52d2dc506bd5
770	17	2019-07-19T13:30:04Z	\N	1	\N	-1	65396002-d1d3-4237-83ee-52d2dc506bd5
771	18	2019-07-19T13:30:04Z	\N	1	\N	-1	65396002-d1d3-4237-83ee-52d2dc506bd5
772	34	Made available in DSpace on 2019-07-19T13:30:04Z (GMT). No. of bitstreams: 2\n007A5P4F2-02.jpg: 5941020 bytes, checksum: f9a87252f065371cc909c6566258048d (MD5)\n007A5P4F2-02.jpg.jpg: 129420 bytes, checksum: 915f5509afb2d6338db4093137646296 (MD5)	en	1	\N	-1	65396002-d1d3-4237-83ee-52d2dc506bd5
773	32	Generated Thumbnail	\N	0	\N	-1	8b3691d8-dde6-4512-bdd2-92f5eaeb47fa
781	32	i: 24,0 x 18,0 cm	pt_BR	1	\N	-1	5affab90-9b3a-4a32-aea4-15fbf5edaf17
785	63	Vertical	pt_BR	1	\N	-1	5affab90-9b3a-4a32-aea4-15fbf5edaf17
794	133	RJ	pt_BR	1	\N	-1	5affab90-9b3a-4a32-aea4-15fbf5edaf17
797	70	ORIGINAL	\N	1	\N	-1	ef47138a-4950-44d5-a967-2247a54bd4ed
774	7	Malta, Augusto	pt_BR	0	\N	-1	5affab90-9b3a-4a32-aea4-15fbf5edaf17
775	16	1931	pt_BR	0	\N	-1	5affab90-9b3a-4a32-aea4-15fbf5edaf17
776	17	2015-10-02T12:32:51Z		0	\N	-1	5affab90-9b3a-4a32-aea4-15fbf5edaf17
777	18	2015-10-02T12:32:51Z		0	\N	-1	5affab90-9b3a-4a32-aea4-15fbf5edaf17
778	23	014AM018001.jpg	pt_BR	0	\N	-1	5affab90-9b3a-4a32-aea4-15fbf5edaf17
780	32	P&B	pt_BR	0	\N	-1	5affab90-9b3a-4a32-aea4-15fbf5edaf17
782	32	Gelatina/ Prata	pt_BR	2	\N	-1	5affab90-9b3a-4a32-aea4-15fbf5edaf17
783	34	Made available in DSpace on 2015-10-02T12:32:51Z (GMT). No. of bitstreams: 1\n014AM018001.jpg: 23163477 bytes, checksum: 113e881971852c00b69a71d5e38a358e (MD5)	en	0	\N	-1	5affab90-9b3a-4a32-aea4-15fbf5edaf17
784	63	PEDRO CORRÊA do LAGO	pt_BR	0	\N	-1	5affab90-9b3a-4a32-aea4-15fbf5edaf17
786	63	Coletivo	pt_BR	2	\N	-1	5affab90-9b3a-4a32-aea4-15fbf5edaf17
787	63	Corcovado	pt_BR	3	\N	-1	5affab90-9b3a-4a32-aea4-15fbf5edaf17
788	63	Diurna	pt_BR	4	\N	-1	5affab90-9b3a-4a32-aea4-15fbf5edaf17
789	63	Externa	pt_BR	5	\N	-1	5affab90-9b3a-4a32-aea4-15fbf5edaf17
790	63	Retrato	pt_BR	6	\N	-1	5affab90-9b3a-4a32-aea4-15fbf5edaf17
791	70	Visita de estudantes ao Cristo Redentor	pt_BR	0	\N	-1	5affab90-9b3a-4a32-aea4-15fbf5edaf17
792	72	Fotografia	pt_BR	0	\N	-1	5affab90-9b3a-4a32-aea4-15fbf5edaf17
793	133	Rio de Janeiro	pt_BR	0	\N	-1	5affab90-9b3a-4a32-aea4-15fbf5edaf17
795	133	Brasil	pt_BR	2	\N	-1	5affab90-9b3a-4a32-aea4-15fbf5edaf17
796	133	Morro do Corcovado	pt_BR	3	\N	-1	5affab90-9b3a-4a32-aea4-15fbf5edaf17
798	70	014AM018001.jpg	\N	0	\N	-1	9cdc3539-a776-4d24-a8c9-af225aebeaf4
799	70	THUMBNAIL	\N	1	\N	-1	22de0971-5c94-408a-b79a-784e7cca0856
800	70	014AM018001.jpg.jpg	\N	0	\N	-1	19b20ec1-9ab1-4fda-a3ae-66601633cb07
801	31	https://hdl.handle.net/20.500.12156.1/3183	\N	0	\N	-1	5affab90-9b3a-4a32-aea4-15fbf5edaf17
802	17	2019-07-19T13:30:07Z	\N	1	\N	-1	5affab90-9b3a-4a32-aea4-15fbf5edaf17
803	18	2019-07-19T13:30:07Z	\N	1	\N	-1	5affab90-9b3a-4a32-aea4-15fbf5edaf17
804	34	Made available in DSpace on 2019-07-19T13:30:07Z (GMT). No. of bitstreams: 2\n014AM018001.jpg: 23163477 bytes, checksum: 113e881971852c00b69a71d5e38a358e (MD5)\n014AM018001.jpg.jpg: 62449 bytes, checksum: aa12ab7e96500fc974bc020594dd1a60 (MD5)	en	1	\N	-1	5affab90-9b3a-4a32-aea4-15fbf5edaf17
805	32	Generated Thumbnail	\N	0	\N	-1	19b20ec1-9ab1-4fda-a3ae-66601633cb07
813	32	i: 16,0 x 24,0 cm	pt_BR	1	\N	-1	7d0a10d2-1ace-4694-b908-79630b8e0b78
817	59	Solicitar imagem junto ao detentor dos direitos indicado no Copyright	pt_BR	1	\N	-1	7d0a10d2-1ace-4694-b908-79630b8e0b78
819	63	Horizontal	pt_BR	1	\N	-1	7d0a10d2-1ace-4694-b908-79630b8e0b78
827	133	Centro	pt_BR	1	\N	-1	7d0a10d2-1ace-4694-b908-79630b8e0b78
830	70	ORIGINAL	\N	1	\N	-1	d5e54765-b028-4723-939d-670ae49d1292
806	7	Malta, Augusto	pt_BR	0	\N	-1	7d0a10d2-1ace-4694-b908-79630b8e0b78
807	16	1928/06/04	pt_BR	0	\N	-1	7d0a10d2-1ace-4694-b908-79630b8e0b78
808	17	2016-06-20T14:06:31Z		0	\N	-1	7d0a10d2-1ace-4694-b908-79630b8e0b78
809	18	2016-06-20T14:06:31Z		0	\N	-1	7d0a10d2-1ace-4694-b908-79630b8e0b78
810	23	014AM005023.jpg	pt_BR	0	\N	-1	7d0a10d2-1ace-4694-b908-79630b8e0b78
812	32	P&B	pt_BR	0	\N	-1	7d0a10d2-1ace-4694-b908-79630b8e0b78
814	32	Gelatina/ Prata	pt_BR	2	\N	-1	7d0a10d2-1ace-4694-b908-79630b8e0b78
815	34	Made available in DSpace on 2016-06-20T14:06:31Z (GMT). No. of bitstreams: 1\n014AM005023.jpg: 12138026 bytes, checksum: d5cd9d883db483ccb8418866b4fe366e (MD5)	en	0	\N	-1	7d0a10d2-1ace-4694-b908-79630b8e0b78
816	59	Instituto Moreira Salles	pt_BR	0	\N	-1	7d0a10d2-1ace-4694-b908-79630b8e0b78
818	63	Engenharia	pt_BR	0	\N	-1	7d0a10d2-1ace-4694-b908-79630b8e0b78
820	63	Morro do Castelo	pt_BR	2	\N	-1	7d0a10d2-1ace-4694-b908-79630b8e0b78
821	63	Externa	pt_BR	3	\N	-1	7d0a10d2-1ace-4694-b908-79630b8e0b78
822	63	PEDRO CORRÊA do LAGO	pt_BR	4	\N	-1	7d0a10d2-1ace-4694-b908-79630b8e0b78
823	63	Obras e demolições	pt_BR	5	\N	-1	7d0a10d2-1ace-4694-b908-79630b8e0b78
824	70	Demolição do Morro do Castelo, ao centro, edifício da Associação Cristã de Moços	pt_BR	0	\N	-1	7d0a10d2-1ace-4694-b908-79630b8e0b78
825	72	Fotografia/ Papel	pt_BR	0	\N	-1	7d0a10d2-1ace-4694-b908-79630b8e0b78
826	133	Rio de Janeiro	pt_BR	0	\N	-1	7d0a10d2-1ace-4694-b908-79630b8e0b78
828	133	RJ	pt_BR	2	\N	-1	7d0a10d2-1ace-4694-b908-79630b8e0b78
829	133	Brasil	pt_BR	3	\N	-1	7d0a10d2-1ace-4694-b908-79630b8e0b78
831	70	014AM005023.jpg	\N	0	\N	-1	0358ba2a-8854-4698-9435-6c8ec90af0b4
832	70	THUMBNAIL	\N	1	\N	-1	a52a46a0-92c0-43f8-9387-bbad149a9a4e
833	70	014AM005023.jpg.jpg	\N	0	\N	-1	8c1442f9-46b5-484b-9d9b-9f3a8761810c
834	31	https://hdl.handle.net/20.500.12156.1/4655	\N	0	\N	-1	7d0a10d2-1ace-4694-b908-79630b8e0b78
835	17	2019-07-19T13:30:09Z	\N	1	\N	-1	7d0a10d2-1ace-4694-b908-79630b8e0b78
836	18	2019-07-19T13:30:09Z	\N	1	\N	-1	7d0a10d2-1ace-4694-b908-79630b8e0b78
837	34	Made available in DSpace on 2019-07-19T13:30:09Z (GMT). No. of bitstreams: 2\n014AM005023.jpg: 12138026 bytes, checksum: d5cd9d883db483ccb8418866b4fe366e (MD5)\n014AM005023.jpg.jpg: 80071 bytes, checksum: fc71d73ab2dafdc9a0e6851e7e173688 (MD5)	en	1	\N	-1	7d0a10d2-1ace-4694-b908-79630b8e0b78
838	32	Generated Thumbnail	\N	0	\N	-1	8c1442f9-46b5-484b-9d9b-9f3a8761810c
846	32	4,5 x 11 cm	pt_BR	1	\N	-1	adad82ef-4c7d-4b61-b07a-4684c037320e
850	59	Solicitar imagem junto ao detentor dos direitos indicado no Copyright	pt_BR	1	\N	-1	adad82ef-4c7d-4b61-b07a-4684c037320e
853	63	Externa	pt_BR	1	\N	-1	adad82ef-4c7d-4b61-b07a-4684c037320e
858	133	Centro	pt_BR	1	\N	-1	adad82ef-4c7d-4b61-b07a-4684c037320e
861	70	ORIGINAL	\N	1	\N	-1	88d5b1c1-f0d7-49c6-adbb-36e87c268f46
839	7	Santos, Guilherme	pt_BR	0	\N	-1	adad82ef-4c7d-4b61-b07a-4684c037320e
840	16	1915	pt_BR	0	\N	-1	adad82ef-4c7d-4b61-b07a-4684c037320e
841	17	2015-04-16T12:51:08Z		0	\N	-1	adad82ef-4c7d-4b61-b07a-4684c037320e
842	18	2015-04-16T12:51:08Z		0	\N	-1	adad82ef-4c7d-4b61-b07a-4684c037320e
843	23	002080BR0206.jpg	pt_BR	0	\N	-1	adad82ef-4c7d-4b61-b07a-4684c037320e
845	32	MONOCROMÁTICA	pt_BR	0	\N	-1	adad82ef-4c7d-4b61-b07a-4684c037320e
847	32	Gelatina/ Prata	pt_BR	2	\N	-1	adad82ef-4c7d-4b61-b07a-4684c037320e
848	34	Made available in DSpace on 2015-04-16T12:51:08Z (GMT). No. of bitstreams: 1\n002080BR0206.jpg: 5112685 bytes, checksum: da669c28facbe08f60b9106af5fd3e42 (MD5)	en	0	\N	-1	adad82ef-4c7d-4b61-b07a-4684c037320e
849	59	Instituto Moreira Salles	pt_BR	0	\N	-1	adad82ef-4c7d-4b61-b07a-4684c037320e
851	61	Instituto Moreira Salles	pt_BR	0	\N	-1	adad82ef-4c7d-4b61-b07a-4684c037320e
852	63	GUILHERME SANTOS	pt_BR	0	\N	-1	adad82ef-4c7d-4b61-b07a-4684c037320e
854	63	Arquitetura	pt_BR	2	\N	-1	adad82ef-4c7d-4b61-b07a-4684c037320e
855	70	Igreja de Santa Luzia, è direita, e Igreja de São Sebastião, no alto do morro do Castelo	pt_BR	0	\N	-1	adad82ef-4c7d-4b61-b07a-4684c037320e
856	72	Diapositivo/ Vidro	pt_BR	0	\N	-1	adad82ef-4c7d-4b61-b07a-4684c037320e
857	133	Rio de Janeiro	pt_BR	0	\N	-1	adad82ef-4c7d-4b61-b07a-4684c037320e
859	133	RJ	pt_BR	2	\N	-1	adad82ef-4c7d-4b61-b07a-4684c037320e
860	133	Brasil	pt_BR	3	\N	-1	adad82ef-4c7d-4b61-b07a-4684c037320e
862	70	002080BR0206.jpg	\N	0	\N	-1	60aa899d-7eba-4202-a780-6db425f03e8c
863	70	THUMBNAIL	\N	1	\N	-1	4b3a9584-97fb-4718-9534-f5028a1b99b8
864	70	002080BR0206.jpg.jpg	\N	0	\N	-1	87a8e209-c582-4259-9586-c0b2abad4611
865	31	https://hdl.handle.net/20.500.12156.1/2059	\N	0	\N	-1	adad82ef-4c7d-4b61-b07a-4684c037320e
866	17	2019-07-19T13:30:10Z	\N	1	\N	-1	adad82ef-4c7d-4b61-b07a-4684c037320e
867	18	2019-07-19T13:30:10Z	\N	1	\N	-1	adad82ef-4c7d-4b61-b07a-4684c037320e
868	34	Made available in DSpace on 2019-07-19T13:30:10Z (GMT). No. of bitstreams: 2\n002080BR0206.jpg: 5112685 bytes, checksum: da669c28facbe08f60b9106af5fd3e42 (MD5)\n002080BR0206.jpg.jpg: 119957 bytes, checksum: 3bb18c48e35e8e094cb10fb1f044ec7d (MD5)	en	1	\N	-1	adad82ef-4c7d-4b61-b07a-4684c037320e
869	32	Generated Thumbnail	\N	0	\N	-1	87a8e209-c582-4259-9586-c0b2abad4611
877	32	i: 21,0 x 27,0 cm; sp: 19,5 x 27,0 cm; ss: 22,0 x29,5 cm.	pt_BR	1	\N	-1	2f3cc1e7-2490-427e-b00f-241dcab457a2
881	59	Solicitar imagem junto ao detentor dos direitos indicado no Copyright	pt_BR	1	\N	-1	2f3cc1e7-2490-427e-b00f-241dcab457a2
884	63	Aspectos Urbanos	pt_BR	1	\N	-1	2f3cc1e7-2490-427e-b00f-241dcab457a2
894	133	RJ	pt_BR	1	\N	-1	2f3cc1e7-2490-427e-b00f-241dcab457a2
896	70	ORIGINAL	\N	1	\N	-1	61b28a3c-d6b7-4bc7-b304-570a3d6ec4fb
870	7	Gutierrez, Juan	pt_BR	0	\N	-1	2f3cc1e7-2490-427e-b00f-241dcab457a2
871	16	1894 circa	pt_BR	0	\N	-1	2f3cc1e7-2490-427e-b00f-241dcab457a2
872	17	2016-06-20T14:06:36Z		0	\N	-1	2f3cc1e7-2490-427e-b00f-241dcab457a2
873	18	2016-06-20T14:06:36Z		0	\N	-1	2f3cc1e7-2490-427e-b00f-241dcab457a2
874	23	001GU001013.jpg	pt_BR	0	\N	-1	2f3cc1e7-2490-427e-b00f-241dcab457a2
876	32	MONOCROMÁTICA	pt_BR	0	\N	-1	2f3cc1e7-2490-427e-b00f-241dcab457a2
878	32	Albumina/ Prata	pt_BR	2	\N	-1	2f3cc1e7-2490-427e-b00f-241dcab457a2
879	34	Made available in DSpace on 2016-06-20T14:06:36Z (GMT). No. of bitstreams: 1\n001GU001013.jpg: 14072542 bytes, checksum: ebe0f8c354db17c3def66ff88ddddb35 (MD5)	en	0	\N	-1	2f3cc1e7-2490-427e-b00f-241dcab457a2
880	59	Instituto Moreira Salles	pt_BR	0	\N	-1	2f3cc1e7-2490-427e-b00f-241dcab457a2
882	61	Coleção Mestres do Séc. XIX	pt_BR	0	\N	-1	2f3cc1e7-2490-427e-b00f-241dcab457a2
883	63	Juan Gutierrez	pt_BR	0	\N	-1	2f3cc1e7-2490-427e-b00f-241dcab457a2
885	63	Horizontal	pt_BR	2	\N	-1	2f3cc1e7-2490-427e-b00f-241dcab457a2
886	63	Acidente Geográfico	pt_BR	3	\N	-1	2f3cc1e7-2490-427e-b00f-241dcab457a2
887	63	Flora / Vegetação	pt_BR	4	\N	-1	2f3cc1e7-2490-427e-b00f-241dcab457a2
888	63	Diurna	pt_BR	5	\N	-1	2f3cc1e7-2490-427e-b00f-241dcab457a2
889	63	Externa	pt_BR	6	\N	-1	2f3cc1e7-2490-427e-b00f-241dcab457a2
890	63	Paisagem	pt_BR	7	\N	-1	2f3cc1e7-2490-427e-b00f-241dcab457a2
891	70	Praia da Lapa e Morro da Glória	pt_BR	0	\N	-1	2f3cc1e7-2490-427e-b00f-241dcab457a2
892	72	Fotografia/ Papel	pt_BR	0	\N	-1	2f3cc1e7-2490-427e-b00f-241dcab457a2
893	133	Rio de Janeiro	pt_BR	0	\N	-1	2f3cc1e7-2490-427e-b00f-241dcab457a2
895	133	Brasil	pt_BR	2	\N	-1	2f3cc1e7-2490-427e-b00f-241dcab457a2
897	70	001GU001013.jpg	\N	0	\N	-1	31ad0de3-e86a-4535-9694-6f206e857d96
898	70	THUMBNAIL	\N	1	\N	-1	ffebcf7e-61b5-4acd-9cec-7919f7a1580a
899	70	001GU001013.jpg.jpg	\N	0	\N	-1	7480d6bd-9a95-4d0c-8f22-e769baf2fca0
900	31	https://hdl.handle.net/20.500.12156.1/4663	\N	0	\N	-1	2f3cc1e7-2490-427e-b00f-241dcab457a2
901	17	2019-07-19T13:30:13Z	\N	1	\N	-1	2f3cc1e7-2490-427e-b00f-241dcab457a2
902	18	2019-07-19T13:30:13Z	\N	1	\N	-1	2f3cc1e7-2490-427e-b00f-241dcab457a2
903	34	Made available in DSpace on 2019-07-19T13:30:13Z (GMT). No. of bitstreams: 2\n001GU001013.jpg: 14072542 bytes, checksum: ebe0f8c354db17c3def66ff88ddddb35 (MD5)\n001GU001013.jpg.jpg: 133697 bytes, checksum: 4400e5a979a90f14aed86236140dcee6 (MD5)	en	1	\N	-1	2f3cc1e7-2490-427e-b00f-241dcab457a2
904	32	Generated Thumbnail	\N	0	\N	-1	7480d6bd-9a95-4d0c-8f22-e769baf2fca0
912	32	sp: 20,0 cm x 26,1cm     ss:26,3 cm x 36,3 cm     st: 26,5 cm x 36,4 cm	pt_BR	1	\N	-1	09ec0ef8-ac24-4a29-a340-261df0304de8
916	59	Solicitar imagem junto ao detentor dos direitos indicado no Copyright	pt_BR	1	\N	-1	09ec0ef8-ac24-4a29-a340-261df0304de8
919	63	Diurna	pt_BR	1	\N	-1	09ec0ef8-ac24-4a29-a340-261df0304de8
927	133	Largo do Machado	pt_BR	1	\N	-1	09ec0ef8-ac24-4a29-a340-261df0304de8
930	70	ORIGINAL	\N	1	\N	-1	85b21ccf-7fe9-4a85-99b8-3f14defd9024
905	7	Stahl & Wahnschaffe	pt_BR	0	\N	-1	09ec0ef8-ac24-4a29-a340-261df0304de8
906	16	1862 circa	pt_BR	0	\N	-1	09ec0ef8-ac24-4a29-a340-261df0304de8
907	17	2015-04-16T12:51:48Z		0	\N	-1	09ec0ef8-ac24-4a29-a340-261df0304de8
908	18	2015-04-16T12:51:48Z		0	\N	-1	09ec0ef8-ac24-4a29-a340-261df0304de8
909	23	007A5P3F05-14.jpg	pt_BR	0	\N	-1	09ec0ef8-ac24-4a29-a340-261df0304de8
911	32	MONOCROMÁTICA	pt_BR	0	\N	-1	09ec0ef8-ac24-4a29-a340-261df0304de8
913	32	Albumina/ Prata	pt_BR	2	\N	-1	09ec0ef8-ac24-4a29-a340-261df0304de8
914	34	Made available in DSpace on 2015-04-16T12:51:48Z (GMT). No. of bitstreams: 1\n007A5P3F05-14.jpg: 8387727 bytes, checksum: 59a5593041836c2869d3af9df6882509 (MD5)	en	0	\N	-1	09ec0ef8-ac24-4a29-a340-261df0304de8
915	59	Instituto Moreira Salles	pt_BR	0	\N	-1	09ec0ef8-ac24-4a29-a340-261df0304de8
917	61	Gilberto Ferrez	pt_BR	0	\N	-1	09ec0ef8-ac24-4a29-a340-261df0304de8
918	63	Horizontal	pt_BR	0	\N	-1	09ec0ef8-ac24-4a29-a340-261df0304de8
920	63	Flora / Vegetação	pt_BR	2	\N	-1	09ec0ef8-ac24-4a29-a340-261df0304de8
921	63	GILBERTO FERREZ	pt_BR	3	\N	-1	09ec0ef8-ac24-4a29-a340-261df0304de8
922	63	Externa	pt_BR	4	\N	-1	09ec0ef8-ac24-4a29-a340-261df0304de8
923	63	Largo do Machado	pt_BR	5	\N	-1	09ec0ef8-ac24-4a29-a340-261df0304de8
924	70	Largo do Machado	pt_BR	0	\N	-1	09ec0ef8-ac24-4a29-a340-261df0304de8
925	72	Fotografia/ Papel	pt_BR	0	\N	-1	09ec0ef8-ac24-4a29-a340-261df0304de8
926	133	Rio de Janeiro	pt_BR	0	\N	-1	09ec0ef8-ac24-4a29-a340-261df0304de8
928	133	RJ	pt_BR	2	\N	-1	09ec0ef8-ac24-4a29-a340-261df0304de8
929	133	Brasil	pt_BR	3	\N	-1	09ec0ef8-ac24-4a29-a340-261df0304de8
931	70	007A5P3F05-14.jpg	\N	0	\N	-1	514b31c8-3dd1-4a4b-b764-85fb7f7ab09c
932	70	THUMBNAIL	\N	1	\N	-1	a40bcc91-5bff-4767-a812-ec14e1da96b0
933	70	007A5P3F05-14.jpg.jpg	\N	0	\N	-1	cf2051c9-5e57-47c6-8fa2-baba200ac735
934	31	https://hdl.handle.net/20.500.12156.1/2152	\N	0	\N	-1	09ec0ef8-ac24-4a29-a340-261df0304de8
935	17	2019-07-19T13:30:14Z	\N	1	\N	-1	09ec0ef8-ac24-4a29-a340-261df0304de8
936	18	2019-07-19T13:30:14Z	\N	1	\N	-1	09ec0ef8-ac24-4a29-a340-261df0304de8
937	34	Made available in DSpace on 2019-07-19T13:30:14Z (GMT). No. of bitstreams: 2\n007A5P3F05-14.jpg: 8387727 bytes, checksum: 59a5593041836c2869d3af9df6882509 (MD5)\n007A5P3F05-14.jpg.jpg: 198726 bytes, checksum: 294643aef5f3c8371b55e40fb2fa56c5 (MD5)	en	1	\N	-1	09ec0ef8-ac24-4a29-a340-261df0304de8
938	32	Generated Thumbnail	\N	0	\N	-1	cf2051c9-5e57-47c6-8fa2-baba200ac735
945	32	i: 25,5 x 17,7 cm	pt_BR	1	\N	-1	d6994539-a007-4084-a892-2620add43f25
949	59	Solicitar imagem junto ao detentor dos direitos indicado no Copyright	pt_BR	1	\N	-1	d6994539-a007-4084-a892-2620add43f25
952	63	Detalhe	pt_BR	1	\N	-1	d6994539-a007-4084-a892-2620add43f25
961	133	Jardim Botânico	pt_BR	1	\N	-1	d6994539-a007-4084-a892-2620add43f25
964	70	ORIGINAL	\N	1	\N	-1	8431ac09-4f3a-43c3-aa3d-1138d3e7fd28
939	16	1890 circa	pt_BR	0	\N	-1	d6994539-a007-4084-a892-2620add43f25
940	17	2015-04-16T12:54:16Z		0	\N	-1	d6994539-a007-4084-a892-2620add43f25
941	18	2015-04-16T12:54:16Z		0	\N	-1	d6994539-a007-4084-a892-2620add43f25
942	23	007SN-20.jpg	pt_BR	0	\N	-1	d6994539-a007-4084-a892-2620add43f25
944	32	MONOCROMÁTICA	pt_BR	0	\N	-1	d6994539-a007-4084-a892-2620add43f25
946	32	Albumina/ Prata	pt_BR	2	\N	-1	d6994539-a007-4084-a892-2620add43f25
947	34	Made available in DSpace on 2015-04-16T12:54:16Z (GMT). No. of bitstreams: 1\n007SN-20.jpg: 32998221 bytes, checksum: e6ebb698e30a605103ab51cb556524c4 (MD5)	en	0	\N	-1	d6994539-a007-4084-a892-2620add43f25
948	59	Instituto Moreira Salles	pt_BR	0	\N	-1	d6994539-a007-4084-a892-2620add43f25
950	61	Gilberto Ferrez	pt_BR	0	\N	-1	d6994539-a007-4084-a892-2620add43f25
951	63	Jardim Botânico	pt_BR	0	\N	-1	d6994539-a007-4084-a892-2620add43f25
953	63	GILBERTO FERREZ	pt_BR	2	\N	-1	d6994539-a007-4084-a892-2620add43f25
954	63	Vertical	pt_BR	3	\N	-1	d6994539-a007-4084-a892-2620add43f25
955	63	Flora / Vegetação	pt_BR	4	\N	-1	d6994539-a007-4084-a892-2620add43f25
956	63	Diurna	pt_BR	5	\N	-1	d6994539-a007-4084-a892-2620add43f25
957	63	Externa	pt_BR	6	\N	-1	d6994539-a007-4084-a892-2620add43f25
958	70	Aléia das Palmeiras do Jardim Botânico	pt_BR	0	\N	-1	d6994539-a007-4084-a892-2620add43f25
959	72	Fotografia/ Papel	pt_BR	0	\N	-1	d6994539-a007-4084-a892-2620add43f25
960	133	Rio de Janeiro	pt_BR	0	\N	-1	d6994539-a007-4084-a892-2620add43f25
962	133	RJ	pt_BR	2	\N	-1	d6994539-a007-4084-a892-2620add43f25
963	133	Brasil	pt_BR	3	\N	-1	d6994539-a007-4084-a892-2620add43f25
965	70	007SN-20.jpg	\N	0	\N	-1	5b5927be-37a7-4643-b553-89419b5a706d
966	70	THUMBNAIL	\N	1	\N	-1	d1e98419-e25f-4d72-a6e3-5c38a98fbc72
967	70	007SN-20.jpg.jpg	\N	0	\N	-1	642a081e-e590-416a-a538-0dd135f0a3d7
968	31	https://hdl.handle.net/20.500.12156.1/2602	\N	0	\N	-1	d6994539-a007-4084-a892-2620add43f25
969	17	2019-07-19T13:30:19Z	\N	1	\N	-1	d6994539-a007-4084-a892-2620add43f25
970	18	2019-07-19T13:30:19Z	\N	1	\N	-1	d6994539-a007-4084-a892-2620add43f25
971	34	Made available in DSpace on 2019-07-19T13:30:19Z (GMT). No. of bitstreams: 2\n007SN-20.jpg: 32998221 bytes, checksum: e6ebb698e30a605103ab51cb556524c4 (MD5)\n007SN-20.jpg.jpg: 114451 bytes, checksum: 2176f9e113a0716add9a8b7d13f56a65 (MD5)	en	1	\N	-1	d6994539-a007-4084-a892-2620add43f25
972	32	Generated Thumbnail	\N	0	\N	-1	642a081e-e590-416a-a538-0dd135f0a3d7
980	32	Gelatina/ Prata	pt_BR	1	\N	-1	d3ed1b45-421a-47cf-b7a3-333df5f5599e
983	59	Solicitar imagem junto ao detentor dos direitos indicado no Copyright	pt_BR	1	\N	-1	d3ed1b45-421a-47cf-b7a3-333df5f5599e
986	63	Horizontal	pt_BR	1	\N	-1	d3ed1b45-421a-47cf-b7a3-333df5f5599e
994	133	RJ	pt_BR	1	\N	-1	d3ed1b45-421a-47cf-b7a3-333df5f5599e
997	70	ORIGINAL	\N	1	\N	-1	9a62e23b-0d7c-47c5-9882-82055f97d477
973	7	Malta, Augusto	pt_BR	0	\N	-1	d3ed1b45-421a-47cf-b7a3-333df5f5599e
974	16	1913/05/31	pt_BR	0	\N	-1	d3ed1b45-421a-47cf-b7a3-333df5f5599e
975	17	2017-01-18T20:31:51Z		0	\N	-1	d3ed1b45-421a-47cf-b7a3-333df5f5599e
976	18	2017-01-18T20:31:51Z		0	\N	-1	d3ed1b45-421a-47cf-b7a3-333df5f5599e
977	23	014AM002006.jpg	pt_BR	0	\N	-1	d3ed1b45-421a-47cf-b7a3-333df5f5599e
979	32	i: 18,0 x 24,0 cm	pt_BR	0	\N	-1	d3ed1b45-421a-47cf-b7a3-333df5f5599e
981	34	Made available in DSpace on 2017-01-18T20:31:51Z (GMT). No. of bitstreams: 1\n014AM002006.jpg: 5054328 bytes, checksum: a2496ded560ef84a1a9dac2d949f5347 (MD5)	en	0	\N	-1	d3ed1b45-421a-47cf-b7a3-333df5f5599e
982	59	Instituto Moreira Salles	pt_BR	0	\N	-1	d3ed1b45-421a-47cf-b7a3-333df5f5599e
984	61	Coleção Pedro Corrêa do Lago	pt_BR	0	\N	-1	d3ed1b45-421a-47cf-b7a3-333df5f5599e
985	63	Cena de rua	pt_BR	0	\N	-1	d3ed1b45-421a-47cf-b7a3-333df5f5599e
987	63	Cerimônias religiosas	pt_BR	2	\N	-1	d3ed1b45-421a-47cf-b7a3-333df5f5599e
988	63	Diurna	pt_BR	3	\N	-1	d3ed1b45-421a-47cf-b7a3-333df5f5599e
989	63	Externa	pt_BR	4	\N	-1	d3ed1b45-421a-47cf-b7a3-333df5f5599e
990	63	PEDRO CORRÊA do LAGO	pt_BR	5	\N	-1	d3ed1b45-421a-47cf-b7a3-333df5f5599e
991	70	Cortejo fúnebre do prefeito Pereira Passos	pt_BR	0	\N	-1	d3ed1b45-421a-47cf-b7a3-333df5f5599e
992	72	Fotografia/ Papel	pt_BR	0	\N	-1	d3ed1b45-421a-47cf-b7a3-333df5f5599e
993	133	Rio de Janeiro	pt_BR	0	\N	-1	d3ed1b45-421a-47cf-b7a3-333df5f5599e
995	133	Brasil	pt_BR	2	\N	-1	d3ed1b45-421a-47cf-b7a3-333df5f5599e
996	133	Praça da República; Centro	pt_BR	3	\N	-1	d3ed1b45-421a-47cf-b7a3-333df5f5599e
998	70	014AM002006.jpg	\N	0	\N	-1	74d3fbca-f981-4a0d-a0ef-5631397f988a
999	70	THUMBNAIL	\N	1	\N	-1	8fb920ce-a656-49ff-a9b5-29f04ace2df9
1000	70	014AM002006.jpg.jpg	\N	0	\N	-1	3102005b-110e-4743-9483-bc06b7d7c546
1001	31	https://hdl.handle.net/20.500.12156.1/4796	\N	0	\N	-1	d3ed1b45-421a-47cf-b7a3-333df5f5599e
1002	17	2019-07-19T13:30:19Z	\N	1	\N	-1	d3ed1b45-421a-47cf-b7a3-333df5f5599e
1003	18	2019-07-19T13:30:19Z	\N	1	\N	-1	d3ed1b45-421a-47cf-b7a3-333df5f5599e
1004	34	Made available in DSpace on 2019-07-19T13:30:19Z (GMT). No. of bitstreams: 2\n014AM002006.jpg: 5054328 bytes, checksum: a2496ded560ef84a1a9dac2d949f5347 (MD5)\n014AM002006.jpg.jpg: 160458 bytes, checksum: 09396e6c13d239ec79620cb6b069e182 (MD5)	en	1	\N	-1	d3ed1b45-421a-47cf-b7a3-333df5f5599e
1005	32	Generated Thumbnail	\N	0	\N	-1	3102005b-110e-4743-9483-bc06b7d7c546
1013	32	i: 9,0 x 5,5 cm; sp: 10,5 x 6,5 cm; ss: 27,0 x 21,0 cm	pt_BR	1	\N	-1	51b13546-800a-44d8-81a1-f84086a43b9c
1017	59	Solicitar imagem junto ao detentor dos direitos indicado no Copyright	pt_BR	1	\N	-1	51b13546-800a-44d8-81a1-f84086a43b9c
1019	63	Estúdio	pt_BR	1	\N	-1	51b13546-800a-44d8-81a1-f84086a43b9c
1025	133	Centro	pt_BR	1	\N	-1	51b13546-800a-44d8-81a1-f84086a43b9c
1028	70	ORIGINAL	\N	1	\N	-1	d5cdecba-6e76-4615-972e-fb7166735f0a
1006	7	Pacheco, Joaquim Insley	pt_BR	0	\N	-1	51b13546-800a-44d8-81a1-f84086a43b9c
1007	16	1880 circa	pt_BR	0	\N	-1	51b13546-800a-44d8-81a1-f84086a43b9c
1008	17	2015-12-22T19:00:50Z		0	\N	-1	51b13546-800a-44d8-81a1-f84086a43b9c
1009	18	2015-12-22T19:00:50Z		0	\N	-1	51b13546-800a-44d8-81a1-f84086a43b9c
1010	23	001AVA009010v.jpg	pt_BR	0	\N	-1	51b13546-800a-44d8-81a1-f84086a43b9c
1012	32	MONOCROMÁTICA	pt_BR	0	\N	-1	51b13546-800a-44d8-81a1-f84086a43b9c
1014	32	Albumina/ Prata	pt_BR	2	\N	-1	51b13546-800a-44d8-81a1-f84086a43b9c
1015	34	Made available in DSpace on 2015-12-22T19:00:50Z (GMT). No. of bitstreams: 1\r\n001AVA009010v.jpg: 14533508 bytes, checksum: 0cc85a4e244aea58117a1b8646fc8fce (MD5)	en	0	\N	-1	51b13546-800a-44d8-81a1-f84086a43b9c
1016	59	Instituto Moreira Salles	pt_BR	0	\N	-1	51b13546-800a-44d8-81a1-f84086a43b9c
1018	63	Carte de visite	pt_BR	0	\N	-1	51b13546-800a-44d8-81a1-f84086a43b9c
1020	63	Retrato	pt_BR	2	\N	-1	51b13546-800a-44d8-81a1-f84086a43b9c
1021	63	Joaquim Insley Pacheco	pt_BR	3	\N	-1	51b13546-800a-44d8-81a1-f84086a43b9c
1022	70	Francisco Anibal Nassif (verso)	pt_BR	0	\N	-1	51b13546-800a-44d8-81a1-f84086a43b9c
1023	72	Fotografia/ Papel	pt_BR	0	\N	-1	51b13546-800a-44d8-81a1-f84086a43b9c
1024	133	Rio de Janeiro	pt_BR	0	\N	-1	51b13546-800a-44d8-81a1-f84086a43b9c
1026	133	RJ	pt_BR	2	\N	-1	51b13546-800a-44d8-81a1-f84086a43b9c
1027	133	Brasil	pt_BR	3	\N	-1	51b13546-800a-44d8-81a1-f84086a43b9c
1029	70	001AVA009010v.jpg	\N	0	\N	-1	ad73097b-7c92-425b-9482-c1b43c3d568b
1030	70	THUMBNAIL	\N	1	\N	-1	0c1c8c49-87ee-4053-b1b8-078b031a4870
1031	70	001AVA009010v.jpg.jpg	\N	0	\N	-1	6473cd49-1948-4391-8616-a73fe1af01ca
1032	31	https://hdl.handle.net/20.500.12156.1/3925	\N	0	\N	-1	51b13546-800a-44d8-81a1-f84086a43b9c
1033	17	2019-07-19T13:30:22Z	\N	1	\N	-1	51b13546-800a-44d8-81a1-f84086a43b9c
1034	18	2019-07-19T13:30:22Z	\N	1	\N	-1	51b13546-800a-44d8-81a1-f84086a43b9c
1035	34	Made available in DSpace on 2019-07-19T13:30:22Z (GMT). No. of bitstreams: 2\n001AVA009010v.jpg: 14533508 bytes, checksum: 0cc85a4e244aea58117a1b8646fc8fce (MD5)\n001AVA009010v.jpg.jpg: 40214 bytes, checksum: e33b958e1decf68d8cf301e3d3209594 (MD5)	en	1	\N	-1	51b13546-800a-44d8-81a1-f84086a43b9c
1036	32	Generated Thumbnail	\N	0	\N	-1	6473cd49-1948-4391-8616-a73fe1af01ca
1044	32	i/sp: 24,0 x 30,0 cm	pt_BR	1	\N	-1	4fc27f14-159f-46ec-90fe-9dfacfbd3632
1049	63	COLEÇÃO GILBERTO FERREZ	pt_BR	1	\N	-1	4fc27f14-159f-46ec-90fe-9dfacfbd3632
1058	133	RJ	pt_BR	1	\N	-1	4fc27f14-159f-46ec-90fe-9dfacfbd3632
1061	70	ORIGINAL	\N	1	\N	-1	408036eb-460c-44f3-823c-0f4f21b5e7d8
1037	7	Ferrez, Marc	pt_BR	0	\N	-1	4fc27f14-159f-46ec-90fe-9dfacfbd3632
1038	16	1906 circa	pt_BR	0	\N	-1	4fc27f14-159f-46ec-90fe-9dfacfbd3632
1039	17	2019-01-08T12:21:23Z		0	\N	-1	4fc27f14-159f-46ec-90fe-9dfacfbd3632
1040	18	2019-01-08T12:21:23Z		0	\N	-1	4fc27f14-159f-46ec-90fe-9dfacfbd3632
1041	23	0072430CX047-02.jpg	pt_BR	0	\N	-1	4fc27f14-159f-46ec-90fe-9dfacfbd3632
1043	32	MONOCROMÁTICA	pt_BR	0	\N	-1	4fc27f14-159f-46ec-90fe-9dfacfbd3632
1045	32	Gelatina/ Prata	pt_BR	2	\N	-1	4fc27f14-159f-46ec-90fe-9dfacfbd3632
1046	34	Made available in DSpace on 2019-01-08T12:21:23Z (GMT). No. of bitstreams: 1\n0072430CX047-02.jpg: 1280837 bytes, checksum: 0defce91000549689b603085021d4517 (MD5)	en	0	\N	-1	4fc27f14-159f-46ec-90fe-9dfacfbd3632
1047	61	Coleção Gilberto Ferrez	pt_BR	0	\N	-1	4fc27f14-159f-46ec-90fe-9dfacfbd3632
1048	63	Aspectos Urbanos	pt_BR	0	\N	-1	4fc27f14-159f-46ec-90fe-9dfacfbd3632
1050	63	Horizontal	pt_BR	2	\N	-1	4fc27f14-159f-46ec-90fe-9dfacfbd3632
1051	63	Hotel	pt_BR	3	\N	-1	4fc27f14-159f-46ec-90fe-9dfacfbd3632
1052	63	Diurna	pt_BR	4	\N	-1	4fc27f14-159f-46ec-90fe-9dfacfbd3632
1053	63	Edifícios e prédios	pt_BR	5	\N	-1	4fc27f14-159f-46ec-90fe-9dfacfbd3632
1054	63	Externa	pt_BR	6	\N	-1	4fc27f14-159f-46ec-90fe-9dfacfbd3632
1055	70	Hotel Avenida, atual edifício Avenida Central,  e ao fundo, o antigo prédio da Imprensa Nacional	pt_BR	0	\N	-1	4fc27f14-159f-46ec-90fe-9dfacfbd3632
1056	72	Negativo/ Vidro	pt_BR	0	\N	-1	4fc27f14-159f-46ec-90fe-9dfacfbd3632
1057	133	Rio de Janeiro	pt_BR	0	\N	-1	4fc27f14-159f-46ec-90fe-9dfacfbd3632
1059	133	Brasil	pt_BR	2	\N	-1	4fc27f14-159f-46ec-90fe-9dfacfbd3632
1060	133	Centro	pt_BR	3	\N	-1	4fc27f14-159f-46ec-90fe-9dfacfbd3632
1062	70	0072430CX047-02.jpg	\N	0	\N	-1	563eb3fb-1600-46cf-86f9-98fdafc3b478
1063	70	THUMBNAIL	\N	1	\N	-1	42f9fb24-ef94-4d14-b9ce-c7fb2bb12c13
1064	70	0072430CX047-02.jpg.jpg	\N	0	\N	-1	13a48304-1c13-43c2-813e-835a1b89cfea
1065	31	https://hdl.handle.net/20.500.12156.1/6243	\N	0	\N	-1	4fc27f14-159f-46ec-90fe-9dfacfbd3632
1066	17	2019-07-19T13:30:23Z	\N	1	\N	-1	4fc27f14-159f-46ec-90fe-9dfacfbd3632
1067	18	2019-07-19T13:30:23Z	\N	1	\N	-1	4fc27f14-159f-46ec-90fe-9dfacfbd3632
1068	34	Made available in DSpace on 2019-07-19T13:30:23Z (GMT). No. of bitstreams: 2\n0072430CX047-02.jpg: 1280837 bytes, checksum: 0defce91000549689b603085021d4517 (MD5)\n0072430CX047-02.jpg.jpg: 120015 bytes, checksum: c1df8c0eeb7a2eb3ecda25a28bb18a85 (MD5)	en	1	\N	-1	4fc27f14-159f-46ec-90fe-9dfacfbd3632
1069	32	Generated Thumbnail	\N	0	\N	-1	13a48304-1c13-43c2-813e-835a1b89cfea
1077	32	Gelatina/ Prata	pt_BR	1	\N	-1	2ff5657d-1e3c-46f3-b842-37c0c6ee32e1
1080	59	Solicitar imagem junto ao detentor dos direitos indicado no Copyright	pt_BR	1	\N	-1	2ff5657d-1e3c-46f3-b842-37c0c6ee32e1
1083	63	Vertical	pt_BR	1	\N	-1	2ff5657d-1e3c-46f3-b842-37c0c6ee32e1
1090	133	RJ	pt_BR	1	\N	-1	2ff5657d-1e3c-46f3-b842-37c0c6ee32e1
1092	70	ORIGINAL	\N	1	\N	-1	95248b9d-2a11-4f62-a952-f4ef8ecf6142
1070	7	Malta, Augusto	pt_BR	0	\N	-1	2ff5657d-1e3c-46f3-b842-37c0c6ee32e1
1071	16	1913	pt_BR	0	\N	-1	2ff5657d-1e3c-46f3-b842-37c0c6ee32e1
1072	17	2015-04-16T12:55:27Z		0	\N	-1	2ff5657d-1e3c-46f3-b842-37c0c6ee32e1
1073	18	2015-04-16T12:55:27Z		0	\N	-1	2ff5657d-1e3c-46f3-b842-37c0c6ee32e1
1074	23	014AM007002.jpg	pt_BR	0	\N	-1	2ff5657d-1e3c-46f3-b842-37c0c6ee32e1
1076	32	i: 22,4 X 16,7 cm	pt_BR	0	\N	-1	2ff5657d-1e3c-46f3-b842-37c0c6ee32e1
1078	34	Made available in DSpace on 2015-04-16T12:55:27Z (GMT). No. of bitstreams: 1\n014AM007002.jpg: 15413436 bytes, checksum: 1c59f72bb08032106054edee11b8ad07 (MD5)	en	0	\N	-1	2ff5657d-1e3c-46f3-b842-37c0c6ee32e1
1079	59	Instituto Moreira Salles	pt_BR	0	\N	-1	2ff5657d-1e3c-46f3-b842-37c0c6ee32e1
1081	61	Pedro Corrêa do Lago	pt_BR	0	\N	-1	2ff5657d-1e3c-46f3-b842-37c0c6ee32e1
1082	63	Coletivo	pt_BR	0	\N	-1	2ff5657d-1e3c-46f3-b842-37c0c6ee32e1
1084	63	Interna	pt_BR	2	\N	-1	2ff5657d-1e3c-46f3-b842-37c0c6ee32e1
1085	63	Carnaval	pt_BR	3	\N	-1	2ff5657d-1e3c-46f3-b842-37c0c6ee32e1
1086	63	PEDRO CORRÊA do LAGO	pt_BR	4	\N	-1	2ff5657d-1e3c-46f3-b842-37c0c6ee32e1
1087	70	Carnaval	pt_BR	0	\N	-1	2ff5657d-1e3c-46f3-b842-37c0c6ee32e1
1088	72	Fotografia	pt_BR	0	\N	-1	2ff5657d-1e3c-46f3-b842-37c0c6ee32e1
1089	133	Rio de Janeiro	pt_BR	0	\N	-1	2ff5657d-1e3c-46f3-b842-37c0c6ee32e1
1091	133	Brasil	pt_BR	2	\N	-1	2ff5657d-1e3c-46f3-b842-37c0c6ee32e1
1093	70	014AM007002.jpg	\N	0	\N	-1	6b5df0be-5101-4525-b6a2-a756c86056df
1094	70	THUMBNAIL	\N	1	\N	-1	eb9ff9c5-5d9d-4de5-a5ea-0fc5f40e2594
1095	70	014AM007002.jpg.jpg	\N	0	\N	-1	5250cc69-87ca-4ef9-8022-5fca19fd092a
1096	31	https://hdl.handle.net/20.500.12156.1/2737	\N	0	\N	-1	2ff5657d-1e3c-46f3-b842-37c0c6ee32e1
1097	17	2019-07-19T13:30:28Z	\N	1	\N	-1	2ff5657d-1e3c-46f3-b842-37c0c6ee32e1
1098	18	2019-07-19T13:30:28Z	\N	1	\N	-1	2ff5657d-1e3c-46f3-b842-37c0c6ee32e1
1099	34	Made available in DSpace on 2019-07-19T13:30:28Z (GMT). No. of bitstreams: 2\n014AM007002.jpg: 15413436 bytes, checksum: 1c59f72bb08032106054edee11b8ad07 (MD5)\n014AM007002.jpg.jpg: 62074 bytes, checksum: 55626c308cf0c5fa564db6496f0148ab (MD5)	en	1	\N	-1	2ff5657d-1e3c-46f3-b842-37c0c6ee32e1
1100	32	Generated Thumbnail	\N	0	\N	-1	5250cc69-87ca-4ef9-8022-5fca19fd092a
1108	32	i: 18,0 x 24,0 cm	pt_BR	1	\N	-1	02e74364-56c7-4094-83cd-164c8db70bfb
1112	59	Solicitar imagem junto ao detentor dos direitos indicado no Copyright	pt_BR	1	\N	-1	02e74364-56c7-4094-83cd-164c8db70bfb
1115	63	Horizontal	pt_BR	1	\N	-1	02e74364-56c7-4094-83cd-164c8db70bfb
1121	133	Botafogo	pt_BR	1	\N	-1	02e74364-56c7-4094-83cd-164c8db70bfb
1124	70	ORIGINAL	\N	1	\N	-1	f0be2af3-8f78-4b7e-908e-da13b7c8f998
1101	7	Malta, Augusto	pt_BR	0	\N	-1	02e74364-56c7-4094-83cd-164c8db70bfb
1102	16	1920 circa	pt_BR	0	\N	-1	02e74364-56c7-4094-83cd-164c8db70bfb
1103	17	2015-04-16T12:55:34Z		0	\N	-1	02e74364-56c7-4094-83cd-164c8db70bfb
1104	18	2015-04-16T12:55:34Z		0	\N	-1	02e74364-56c7-4094-83cd-164c8db70bfb
1105	23	014AM012005.jpg	pt_BR	0	\N	-1	02e74364-56c7-4094-83cd-164c8db70bfb
1107	32	P&B	pt_BR	0	\N	-1	02e74364-56c7-4094-83cd-164c8db70bfb
1109	32	Gelatina/ Prata	pt_BR	2	\N	-1	02e74364-56c7-4094-83cd-164c8db70bfb
1110	34	Made available in DSpace on 2015-04-16T12:55:34Z (GMT). No. of bitstreams: 1\n014AM012005.jpg: 23261993 bytes, checksum: f67c903fd3e17bb21326919691628a8b (MD5)	en	0	\N	-1	02e74364-56c7-4094-83cd-164c8db70bfb
1111	59	Instituto Moreira Salles	pt_BR	0	\N	-1	02e74364-56c7-4094-83cd-164c8db70bfb
1113	61	Pedro Corrêa do Lago	pt_BR	0	\N	-1	02e74364-56c7-4094-83cd-164c8db70bfb
1114	63	Detalhe	pt_BR	0	\N	-1	02e74364-56c7-4094-83cd-164c8db70bfb
1116	63	Externa	pt_BR	2	\N	-1	02e74364-56c7-4094-83cd-164c8db70bfb
1117	63	PEDRO CORRÊA do LAGO	pt_BR	3	\N	-1	02e74364-56c7-4094-83cd-164c8db70bfb
1118	70	Rua Voluntários da Pátria	pt_BR	0	\N	-1	02e74364-56c7-4094-83cd-164c8db70bfb
1119	72	Fotografia/ Papel	pt_BR	0	\N	-1	02e74364-56c7-4094-83cd-164c8db70bfb
1120	133	Rio de Janeiro	pt_BR	0	\N	-1	02e74364-56c7-4094-83cd-164c8db70bfb
1122	133	RJ	pt_BR	2	\N	-1	02e74364-56c7-4094-83cd-164c8db70bfb
1123	133	Brasil	pt_BR	3	\N	-1	02e74364-56c7-4094-83cd-164c8db70bfb
1125	70	014AM012005.jpg	\N	0	\N	-1	6bc6311a-46c9-4954-b020-5ce23c722fec
1126	70	THUMBNAIL	\N	1	\N	-1	1640fc10-07f2-4ac9-ad35-5ca970d7e3dc
1127	70	014AM012005.jpg.jpg	\N	0	\N	-1	75b52b9d-9bc1-4c9e-b99e-e6e6914f9b74
1128	31	https://hdl.handle.net/20.500.12156.1/2754	\N	0	\N	-1	02e74364-56c7-4094-83cd-164c8db70bfb
1129	17	2019-07-19T13:30:35Z	\N	1	\N	-1	02e74364-56c7-4094-83cd-164c8db70bfb
1130	18	2019-07-19T13:30:35Z	\N	1	\N	-1	02e74364-56c7-4094-83cd-164c8db70bfb
1131	34	Made available in DSpace on 2019-07-19T13:30:35Z (GMT). No. of bitstreams: 2\n014AM012005.jpg: 23261993 bytes, checksum: f67c903fd3e17bb21326919691628a8b (MD5)\n014AM012005.jpg.jpg: 139511 bytes, checksum: 84c35daa89ed4d8f607e7af339b1da2d (MD5)	en	1	\N	-1	02e74364-56c7-4094-83cd-164c8db70bfb
1132	32	Generated Thumbnail	\N	0	\N	-1	75b52b9d-9bc1-4c9e-b99e-e6e6914f9b74
1140	32	i: 17,2 x 22,7 cm / sp: 17,3 x 23 cm	pt_BR	1	\N	-1	e729bb52-e369-4170-a38c-a011feddaedb
1144	59	Liberado apenas para uso de natureza cultural	pt_BR	1	\N	-1	e729bb52-e369-4170-a38c-a011feddaedb
1147	63	COLEÇÃO IMS	pt_BR	1	\N	-1	e729bb52-e369-4170-a38c-a011feddaedb
1157	133	RJ	pt_BR	1	\N	-1	e729bb52-e369-4170-a38c-a011feddaedb
1160	70	THUMBNAIL	\N	1	\N	-1	9817e8d8-8eee-42b4-a188-b360ee9d1f3c
1133	7	Malta, Augusto	pt_BR	0	\N	-1	e729bb52-e369-4170-a38c-a011feddaedb
1134	16	1922	pt_BR	0	\N	-1	e729bb52-e369-4170-a38c-a011feddaedb
1135	17	2019-03-08T13:29:51Z		0	\N	-1	e729bb52-e369-4170-a38c-a011feddaedb
1136	18	2019-03-08T13:29:51Z		0	\N	-1	e729bb52-e369-4170-a38c-a011feddaedb
1137	23	002051AM001003.jpg	pt_BR	0	\N	-1	e729bb52-e369-4170-a38c-a011feddaedb
1139	32	P&B	pt_BR	0	\N	-1	e729bb52-e369-4170-a38c-a011feddaedb
1141	32	Gelatina/ Prata	pt_BR	2	\N	-1	e729bb52-e369-4170-a38c-a011feddaedb
1142	34	Made available in DSpace on 2019-03-08T13:29:51Z (GMT). No. of bitstreams: 1\n002051AM001003.jpg: 2605533 bytes, checksum: 9b4a2f165e15063c4a139244468869ad (MD5)	en	0	\N	-1	e729bb52-e369-4170-a38c-a011feddaedb
1143	59	Instituto Moreira Salles	pt_BR	0	\N	-1	e729bb52-e369-4170-a38c-a011feddaedb
1145	61	Coleção Instituto Moreira Salles	pt_BR	0	\N	-1	e729bb52-e369-4170-a38c-a011feddaedb
1146	63	Eventos / Cerimônias	pt_BR	0	\N	-1	e729bb52-e369-4170-a38c-a011feddaedb
1148	63	Esplanada do Castelo	pt_BR	2	\N	-1	e729bb52-e369-4170-a38c-a011feddaedb
1149	63	Horizontal	pt_BR	3	\N	-1	e729bb52-e369-4170-a38c-a011feddaedb
1150	63	Arquitetura	pt_BR	4	\N	-1	e729bb52-e369-4170-a38c-a011feddaedb
1151	63	AUGUSTO MALTA	pt_BR	5	\N	-1	e729bb52-e369-4170-a38c-a011feddaedb
1152	63	Diurna	pt_BR	6	\N	-1	e729bb52-e369-4170-a38c-a011feddaedb
1153	63	Externa	pt_BR	7	\N	-1	e729bb52-e369-4170-a38c-a011feddaedb
1154	70	Vista do Pavilhão da Itália, integrante da Exposição Internacional do Centenário da Independência do Brasil	pt_BR	0	\N	-1	e729bb52-e369-4170-a38c-a011feddaedb
1155	72	Fotografia/ Papel	pt_BR	0	\N	-1	e729bb52-e369-4170-a38c-a011feddaedb
1156	133	Rio de Janeiro	pt_BR	0	\N	-1	e729bb52-e369-4170-a38c-a011feddaedb
1158	133	Brasil	pt_BR	2	\N	-1	e729bb52-e369-4170-a38c-a011feddaedb
1159	133	Esplanada do Castelo	pt_BR	3	\N	-1	e729bb52-e369-4170-a38c-a011feddaedb
1161	70	002051AM001003.jpg.jpg	\N	0	\N	-1	04aca341-8975-4406-b960-95542b8dff79
1162	70	ORIGINAL	\N	1	\N	-1	7a1434b7-6895-4f14-a80b-c2b1205bac55
1163	70	002051AM001003.jpg	\N	0	\N	-1	fccef367-c66f-4c8b-b5b1-6c0c0bc26f06
1164	31	https://hdl.handle.net/20.500.12156.1/6391	\N	0	\N	-1	e729bb52-e369-4170-a38c-a011feddaedb
1165	17	2019-07-19T13:30:37Z	\N	1	\N	-1	e729bb52-e369-4170-a38c-a011feddaedb
1166	18	2019-07-19T13:30:37Z	\N	1	\N	-1	e729bb52-e369-4170-a38c-a011feddaedb
1167	34	Made available in DSpace on 2019-07-19T13:30:37Z (GMT). No. of bitstreams: 2\n002051AM001003.jpg.jpg: 133813 bytes, checksum: 1b1640e13b176018c8c7ab7e0c4563c8 (MD5)\n002051AM001003.jpg: 2605533 bytes, checksum: 9b4a2f165e15063c4a139244468869ad (MD5)	en	1	\N	-1	e729bb52-e369-4170-a38c-a011feddaedb
1168	32	Generated Thumbnail	\N	0	\N	-1	04aca341-8975-4406-b960-95542b8dff79
1176	32	i/sp:19,4 cm x 24,3 cm      ss:31,2 cm x 41,3 cm	pt_BR	1	\N	-1	b49f6ec8-5476-4b8c-8eab-63f99a7d46b2
1180	59	Solicitar imagem junto ao detentor dos direitos indicado no Copyright	pt_BR	1	\N	-1	b49f6ec8-5476-4b8c-8eab-63f99a7d46b2
1183	63	GILBERTO FERREZ	pt_BR	1	\N	-1	b49f6ec8-5476-4b8c-8eab-63f99a7d46b2
1192	133	Botafogo	pt_BR	1	\N	-1	b49f6ec8-5476-4b8c-8eab-63f99a7d46b2
1195	70	ORIGINAL	\N	1	\N	-1	a8fad082-f1f4-49f9-a73d-7df879ca8df3
1169	7	Leuzinger, Georges	pt_BR	0	\N	-1	b49f6ec8-5476-4b8c-8eab-63f99a7d46b2
1170	16	1870 circa	pt_BR	0	\N	-1	b49f6ec8-5476-4b8c-8eab-63f99a7d46b2
1171	17	2015-04-16T12:52:41Z		0	\N	-1	b49f6ec8-5476-4b8c-8eab-63f99a7d46b2
1172	18	2015-04-16T12:52:41Z		0	\N	-1	b49f6ec8-5476-4b8c-8eab-63f99a7d46b2
1173	23	007A5P3FG5-13.jpg	pt_BR	0	\N	-1	b49f6ec8-5476-4b8c-8eab-63f99a7d46b2
1175	32	P&B	pt_BR	0	\N	-1	b49f6ec8-5476-4b8c-8eab-63f99a7d46b2
1177	32	Albumina/ Prata	pt_BR	2	\N	-1	b49f6ec8-5476-4b8c-8eab-63f99a7d46b2
1178	34	Made available in DSpace on 2015-04-16T12:52:41Z (GMT). No. of bitstreams: 1\n007A5P3FG5-13.jpg: 6122908 bytes, checksum: e97a950b75915073892ba6c8bcafd64c (MD5)	en	0	\N	-1	b49f6ec8-5476-4b8c-8eab-63f99a7d46b2
1179	59	Instituto Moreira Salles	pt_BR	0	\N	-1	b49f6ec8-5476-4b8c-8eab-63f99a7d46b2
1181	61	Gilberto Ferrez	pt_BR	0	\N	-1	b49f6ec8-5476-4b8c-8eab-63f99a7d46b2
1182	63	Aspectos Urbanos	pt_BR	0	\N	-1	b49f6ec8-5476-4b8c-8eab-63f99a7d46b2
1184	63	Horizontal	pt_BR	2	\N	-1	b49f6ec8-5476-4b8c-8eab-63f99a7d46b2
1185	63	Acidente Geográfico	pt_BR	3	\N	-1	b49f6ec8-5476-4b8c-8eab-63f99a7d46b2
1186	63	Flora / Vegetação	pt_BR	4	\N	-1	b49f6ec8-5476-4b8c-8eab-63f99a7d46b2
1187	63	Diurna	pt_BR	5	\N	-1	b49f6ec8-5476-4b8c-8eab-63f99a7d46b2
1188	63	Externa	pt_BR	6	\N	-1	b49f6ec8-5476-4b8c-8eab-63f99a7d46b2
1189	70	São Clemente, Botafogo e Flamengo	pt_BR	0	\N	-1	b49f6ec8-5476-4b8c-8eab-63f99a7d46b2
1190	72	Fotografia/ Papel	pt_BR	0	\N	-1	b49f6ec8-5476-4b8c-8eab-63f99a7d46b2
1191	133	Rio de Janeiro	pt_BR	0	\N	-1	b49f6ec8-5476-4b8c-8eab-63f99a7d46b2
1193	133	RJ	pt_BR	2	\N	-1	b49f6ec8-5476-4b8c-8eab-63f99a7d46b2
1194	133	Brasil	pt_BR	3	\N	-1	b49f6ec8-5476-4b8c-8eab-63f99a7d46b2
1196	70	007A5P3FG5-13.jpg	\N	0	\N	-1	c4bd7804-502e-48f8-a12b-8b87d142393f
1197	70	THUMBNAIL	\N	1	\N	-1	ea1a91b4-37c3-4606-9f2a-bbe2e77dd621
1198	70	007A5P3FG5-13.jpg.jpg	\N	0	\N	-1	fecf442d-6eb8-4578-b194-7401b6ca6147
1199	31	https://hdl.handle.net/20.500.12156.1/2305	\N	0	\N	-1	b49f6ec8-5476-4b8c-8eab-63f99a7d46b2
1200	17	2019-07-19T13:30:39Z	\N	1	\N	-1	b49f6ec8-5476-4b8c-8eab-63f99a7d46b2
1201	18	2019-07-19T13:30:39Z	\N	1	\N	-1	b49f6ec8-5476-4b8c-8eab-63f99a7d46b2
1202	34	Made available in DSpace on 2019-07-19T13:30:39Z (GMT). No. of bitstreams: 2\n007A5P3FG5-13.jpg: 6122908 bytes, checksum: e97a950b75915073892ba6c8bcafd64c (MD5)\n007A5P3FG5-13.jpg.jpg: 109537 bytes, checksum: 12031af1f80e84878e2cda6d07414c63 (MD5)	en	1	\N	-1	b49f6ec8-5476-4b8c-8eab-63f99a7d46b2
1203	32	Generated Thumbnail	\N	0	\N	-1	fecf442d-6eb8-4578-b194-7401b6ca6147
1211	32	i: 4,5 x 11 cm	pt_BR	1	\N	-1	97b1eb6d-cf2f-41bb-8943-bb70f042485a
1215	59	Solicitar imagem junto ao detentor dos direitos indicado no Copyright	pt_BR	1	\N	-1	97b1eb6d-cf2f-41bb-8943-bb70f042485a
1218	63	COLEÇÃO IMS	pt_BR	1	\N	-1	97b1eb6d-cf2f-41bb-8943-bb70f042485a
1227	133	Glória	pt_BR	1	\N	-1	97b1eb6d-cf2f-41bb-8943-bb70f042485a
1230	70	ORIGINAL	\N	1	\N	-1	cdb86a05-b0b4-497f-8808-534d330ef40f
1204	7	Santos, Guilherme	pt_BR	0	\N	-1	97b1eb6d-cf2f-41bb-8943-bb70f042485a
1205	16	1920	pt_BR	0	\N	-1	97b1eb6d-cf2f-41bb-8943-bb70f042485a
1206	17	2016-09-15T21:21:35Z		0	\N	-1	97b1eb6d-cf2f-41bb-8943-bb70f042485a
1207	18	2016-09-15T21:21:35Z		0	\N	-1	97b1eb6d-cf2f-41bb-8943-bb70f042485a
1208	23	002080Vol01Cx0307.jpg	pt_BR	0	\N	-1	97b1eb6d-cf2f-41bb-8943-bb70f042485a
1210	32	MONOCROMÁTICA	pt_BR	0	\N	-1	97b1eb6d-cf2f-41bb-8943-bb70f042485a
1212	32	Gelatina/ Prata	pt_BR	2	\N	-1	97b1eb6d-cf2f-41bb-8943-bb70f042485a
1213	34	Made available in DSpace on 2016-09-15T21:21:35Z (GMT). No. of bitstreams: 1\n002080Vol01Cx0307.jpg: 4395952 bytes, checksum: 535ca0cdab30ef173b51326f787a1339 (MD5)	en	0	\N	-1	97b1eb6d-cf2f-41bb-8943-bb70f042485a
1214	59	Instituto Moreira Salles	pt_BR	0	\N	-1	97b1eb6d-cf2f-41bb-8943-bb70f042485a
1216	61	Coleção Instituto Moreira Salles	pt_BR	0	\N	-1	97b1eb6d-cf2f-41bb-8943-bb70f042485a
1217	63	Eventos / Cerimônias	pt_BR	0	\N	-1	97b1eb6d-cf2f-41bb-8943-bb70f042485a
1219	63	Bairro da Glória	pt_BR	2	\N	-1	97b1eb6d-cf2f-41bb-8943-bb70f042485a
1220	63	Pessoas	pt_BR	3	\N	-1	97b1eb6d-cf2f-41bb-8943-bb70f042485a
1221	63	Montanha	pt_BR	4	\N	-1	97b1eb6d-cf2f-41bb-8943-bb70f042485a
1222	63	GUILHERME SANTOS	pt_BR	5	\N	-1	97b1eb6d-cf2f-41bb-8943-bb70f042485a
1223	63	Morro do Pão de Açúcar	pt_BR	6	\N	-1	97b1eb6d-cf2f-41bb-8943-bb70f042485a
1224	70	Visita do Rei da Bélgica, Alberto I	pt_BR	0	\N	-1	97b1eb6d-cf2f-41bb-8943-bb70f042485a
1225	72	Diapositivo/ Vidro	pt_BR	0	\N	-1	97b1eb6d-cf2f-41bb-8943-bb70f042485a
1226	133	Rio de Janeiro	pt_BR	0	\N	-1	97b1eb6d-cf2f-41bb-8943-bb70f042485a
1228	133	RJ	pt_BR	2	\N	-1	97b1eb6d-cf2f-41bb-8943-bb70f042485a
1229	133	Brasil	pt_BR	3	\N	-1	97b1eb6d-cf2f-41bb-8943-bb70f042485a
1231	70	002080Vol01Cx0307.jpg	\N	0	\N	-1	81d538ed-1831-40bc-827c-1b7ea43eef30
1232	70	THUMBNAIL	\N	1	\N	-1	7f71e243-6c60-4665-8f1e-cd04ea138d94
1233	70	002080Vol01Cx0307.jpg.jpg	\N	0	\N	-1	de55033f-24a1-4b83-9b2c-e13cbc76fb92
1234	31	https://hdl.handle.net/20.500.12156.1/4724	\N	0	\N	-1	97b1eb6d-cf2f-41bb-8943-bb70f042485a
1235	17	2019-07-19T13:30:41Z	\N	1	\N	-1	97b1eb6d-cf2f-41bb-8943-bb70f042485a
1236	18	2019-07-19T13:30:41Z	\N	1	\N	-1	97b1eb6d-cf2f-41bb-8943-bb70f042485a
1237	34	Made available in DSpace on 2019-07-19T13:30:41Z (GMT). No. of bitstreams: 2\n002080Vol01Cx0307.jpg: 4395952 bytes, checksum: 535ca0cdab30ef173b51326f787a1339 (MD5)\n002080Vol01Cx0307.jpg.jpg: 151442 bytes, checksum: 05da4634c31ce6d1856b0801a3dd92d4 (MD5)	en	1	\N	-1	97b1eb6d-cf2f-41bb-8943-bb70f042485a
1238	32	Generated Thumbnail	\N	0	\N	-1	de55033f-24a1-4b83-9b2c-e13cbc76fb92
1246	32	sp: 21,0 x 37,0 cm	pt_BR	1	\N	-1	c0b68a77-7569-45c4-a10b-2d3fca4fed29
1253	63	Panorama	pt_BR	1	\N	-1	c0b68a77-7569-45c4-a10b-2d3fca4fed29
1250	59	Solicitar imagem junto ao detentor dos direitos indicado no Copyright	pt_BR	1	\N	-1	c0b68a77-7569-45c4-a10b-2d3fca4fed29
1264	133	Centro	pt_BR	1	\N	-1	c0b68a77-7569-45c4-a10b-2d3fca4fed29
1267	70	ORIGINAL	\N	1	\N	-1	a7a81151-eac6-41ca-ac57-07c5f3e32100
1239	7	Ferrez, Marc	pt_BR	0	\N	-1	c0b68a77-7569-45c4-a10b-2d3fca4fed29
1240	16	1903 circa	pt_BR	0	\N	-1	c0b68a77-7569-45c4-a10b-2d3fca4fed29
1241	17	2016-06-20T15:16:55Z		0	\N	-1	c0b68a77-7569-45c4-a10b-2d3fca4fed29
1242	18	2016-06-20T15:16:55Z		0	\N	-1	c0b68a77-7569-45c4-a10b-2d3fca4fed29
1243	23	0072137cx010.JPG	pt_BR	0	\N	-1	c0b68a77-7569-45c4-a10b-2d3fca4fed29
1245	32	MONOCROMÁTICA	pt_BR	0	\N	-1	c0b68a77-7569-45c4-a10b-2d3fca4fed29
1247	32	Gelatina/ Prata	pt_BR	2	\N	-1	c0b68a77-7569-45c4-a10b-2d3fca4fed29
1248	34	Made available in DSpace on 2016-06-20T15:16:55Z (GMT). No. of bitstreams: 1\n0072137cx010.JPG: 7163118 bytes, checksum: 7cee6345994146d3140d90c844cb7b5b (MD5)	en	0	\N	-1	c0b68a77-7569-45c4-a10b-2d3fca4fed29
1249	59	Instituto Moreira Salles	pt_BR	0	\N	-1	c0b68a77-7569-45c4-a10b-2d3fca4fed29
1251	61	Coleção Gilberto Ferrez	pt_BR	0	\N	-1	c0b68a77-7569-45c4-a10b-2d3fca4fed29
1252	63	Paço Imperial	pt_BR	0	\N	-1	c0b68a77-7569-45c4-a10b-2d3fca4fed29
1254	63	GILBERTO FERREZ	pt_BR	2	\N	-1	c0b68a77-7569-45c4-a10b-2d3fca4fed29
1255	63	Seleção Site	pt_BR	3	\N	-1	c0b68a77-7569-45c4-a10b-2d3fca4fed29
1256	63	Horizontal	pt_BR	4	\N	-1	c0b68a77-7569-45c4-a10b-2d3fca4fed29
1257	63	Diurna	pt_BR	5	\N	-1	c0b68a77-7569-45c4-a10b-2d3fca4fed29
1258	63	Seleção Site	pt_BR	6	\N	-1	c0b68a77-7569-45c4-a10b-2d3fca4fed29
1259	63	Praça XV de Novembro	pt_BR	7	\N	-1	c0b68a77-7569-45c4-a10b-2d3fca4fed29
1260	63	Externa	pt_BR	8	\N	-1	c0b68a77-7569-45c4-a10b-2d3fca4fed29
1261	70	Vista da Praça XV	pt_BR	0	\N	-1	c0b68a77-7569-45c4-a10b-2d3fca4fed29
1262	72	Negativo/ Vidro	pt_BR	0	\N	-1	c0b68a77-7569-45c4-a10b-2d3fca4fed29
1263	133	Rio de Janeiro	pt_BR	0	\N	-1	c0b68a77-7569-45c4-a10b-2d3fca4fed29
1265	133	RJ	pt_BR	2	\N	-1	c0b68a77-7569-45c4-a10b-2d3fca4fed29
1266	133	Brasil	pt_BR	3	\N	-1	c0b68a77-7569-45c4-a10b-2d3fca4fed29
1268	70	0072137cx010.JPG	\N	0	\N	-1	8baccd65-9cbb-4638-9c41-52bab8ef13c4
1269	70	THUMBNAIL	\N	1	\N	-1	18fd7b92-a579-4299-97ca-00c53e30065f
1270	70	0072137cx010.JPG.jpg	\N	0	\N	-1	3ab19994-833d-493e-9c68-b71539f851e4
1271	31	https://hdl.handle.net/20.500.12156.1/4677	\N	0	\N	-1	c0b68a77-7569-45c4-a10b-2d3fca4fed29
1272	17	2019-07-19T13:30:43Z	\N	1	\N	-1	c0b68a77-7569-45c4-a10b-2d3fca4fed29
1273	18	2019-07-19T13:30:43Z	\N	1	\N	-1	c0b68a77-7569-45c4-a10b-2d3fca4fed29
1274	34	Made available in DSpace on 2019-07-19T13:30:43Z (GMT). No. of bitstreams: 2\n0072137cx010.JPG: 7163118 bytes, checksum: 7cee6345994146d3140d90c844cb7b5b (MD5)\n0072137cx010.JPG.jpg: 142571 bytes, checksum: bb564b98101e8340a3391b9c12b7990e (MD5)	en	1	\N	-1	c0b68a77-7569-45c4-a10b-2d3fca4fed29
1275	32	Generated Thumbnail	\N	0	\N	-1	3ab19994-833d-493e-9c68-b71539f851e4
1283	32	i:23,2 cm x 29,3 cm	pt_BR	1	\N	-1	6ef6ce81-f0f0-4345-8faa-081139d4e475
1287	59	Solicitar imagem junto ao detentor dos direitos indicado no Copyright	pt_BR	1	\N	-1	6ef6ce81-f0f0-4345-8faa-081139d4e475
1290	63	Cena de rua	pt_BR	1	\N	-1	6ef6ce81-f0f0-4345-8faa-081139d4e475
1300	133	Centro	pt_BR	1	\N	-1	6ef6ce81-f0f0-4345-8faa-081139d4e475
1303	70	ORIGINAL	\N	1	\N	-1	58114c56-4af2-4df8-9ccf-11f62861190d
1276	7	Malta, Augusto	pt_BR	0	\N	-1	6ef6ce81-f0f0-4345-8faa-081139d4e475
1277	16	1909/03/15	pt_BR	0	\N	-1	6ef6ce81-f0f0-4345-8faa-081139d4e475
1278	17	2015-04-16T12:53:19Z		0	\N	-1	6ef6ce81-f0f0-4345-8faa-081139d4e475
1279	18	2015-04-16T12:53:19Z		0	\N	-1	6ef6ce81-f0f0-4345-8faa-081139d4e475
1280	23	007A5P4F1-13.jpg	pt_BR	0	\N	-1	6ef6ce81-f0f0-4345-8faa-081139d4e475
1282	32	P&B	pt_BR	0	\N	-1	6ef6ce81-f0f0-4345-8faa-081139d4e475
1284	32	Gelatina/ Prata	pt_BR	2	\N	-1	6ef6ce81-f0f0-4345-8faa-081139d4e475
1285	34	Made available in DSpace on 2015-04-16T12:53:19Z (GMT). No. of bitstreams: 1\n007A5P4F1-13.jpg: 1137580 bytes, checksum: b4cb3b569124e9ea32e43f7ed2c0b30d (MD5)	en	0	\N	-1	6ef6ce81-f0f0-4345-8faa-081139d4e475
1286	59	Instituto Moreira Salles	pt_BR	0	\N	-1	6ef6ce81-f0f0-4345-8faa-081139d4e475
1288	61	Gilberto Ferrez	pt_BR	0	\N	-1	6ef6ce81-f0f0-4345-8faa-081139d4e475
1289	63	Largo da Sé	pt_BR	0	\N	-1	6ef6ce81-f0f0-4345-8faa-081139d4e475
1291	63	GILBERTO FERREZ	pt_BR	2	\N	-1	6ef6ce81-f0f0-4345-8faa-081139d4e475
1292	63	Largo de São Francisco de Paula (Rio de Janeiro)	pt_BR	3	\N	-1	6ef6ce81-f0f0-4345-8faa-081139d4e475
1293	63	Pessoas	pt_BR	4	\N	-1	6ef6ce81-f0f0-4345-8faa-081139d4e475
1294	63	Horizontal	pt_BR	5	\N	-1	6ef6ce81-f0f0-4345-8faa-081139d4e475
1295	63	Diurna	pt_BR	6	\N	-1	6ef6ce81-f0f0-4345-8faa-081139d4e475
1296	63	Externa	pt_BR	7	\N	-1	6ef6ce81-f0f0-4345-8faa-081139d4e475
1297	70	Largo da Sé (atual Largo de São Francisco de Paula)	pt_BR	0	\N	-1	6ef6ce81-f0f0-4345-8faa-081139d4e475
1298	72	Fotografia/ Papel	pt_BR	0	\N	-1	6ef6ce81-f0f0-4345-8faa-081139d4e475
1299	133	Rio de Janeiro	pt_BR	0	\N	-1	6ef6ce81-f0f0-4345-8faa-081139d4e475
1301	133	RJ	pt_BR	2	\N	-1	6ef6ce81-f0f0-4345-8faa-081139d4e475
1302	133	Brasil	pt_BR	3	\N	-1	6ef6ce81-f0f0-4345-8faa-081139d4e475
1304	70	007A5P4F1-13.jpg	\N	0	\N	-1	ade000fc-2740-47e4-abc4-5f501ea69256
1305	70	THUMBNAIL	\N	1	\N	-1	b0af88a3-1267-44fa-a33e-e69f6652c53f
1306	70	007A5P4F1-13.jpg.jpg	\N	0	\N	-1	5a041b16-cf3c-4730-91d3-cc92e9f94444
1307	31	https://hdl.handle.net/20.500.12156.1/2419	\N	0	\N	-1	6ef6ce81-f0f0-4345-8faa-081139d4e475
1308	17	2019-07-19T13:30:44Z	\N	1	\N	-1	6ef6ce81-f0f0-4345-8faa-081139d4e475
1309	18	2019-07-19T13:30:44Z	\N	1	\N	-1	6ef6ce81-f0f0-4345-8faa-081139d4e475
1310	34	Made available in DSpace on 2019-07-19T13:30:44Z (GMT). No. of bitstreams: 2\n007A5P4F1-13.jpg: 1137580 bytes, checksum: b4cb3b569124e9ea32e43f7ed2c0b30d (MD5)\n007A5P4F1-13.jpg.jpg: 138919 bytes, checksum: 9c6f025b88f4641ce84d14a07db1f7dc (MD5)	en	1	\N	-1	6ef6ce81-f0f0-4345-8faa-081139d4e475
1311	32	Generated Thumbnail	\N	0	\N	-1	5a041b16-cf3c-4730-91d3-cc92e9f94444
1321	59	Solicitar imagem junto ao detentor dos direitos indicado no Copyright	pt_BR	1	\N	-1	16c0c95b-6b04-4f57-9c5c-03c975d4daf4
1324	63	Arquitetura	pt_BR	1	\N	-1	16c0c95b-6b04-4f57-9c5c-03c975d4daf4
1331	133	Rua Santo Amaro	pt_BR	1	\N	-1	16c0c95b-6b04-4f57-9c5c-03c975d4daf4
1334	70	ORIGINAL	\N	1	\N	-1	2cd4b643-8b70-4e10-9ae9-6ac90e6e82ac
1312	7	Ferrez, Marc	pt_BR	0	\N	-1	16c0c95b-6b04-4f57-9c5c-03c975d4daf4
1313	16	1880 circa	pt_BR	0	\N	-1	16c0c95b-6b04-4f57-9c5c-03c975d4daf4
1314	17	2015-04-16T12:52:32Z		0	\N	-1	16c0c95b-6b04-4f57-9c5c-03c975d4daf4
1315	18	2015-04-16T12:52:32Z		0	\N	-1	16c0c95b-6b04-4f57-9c5c-03c975d4daf4
1316	23	007A5P3FG2-51.jpg	pt_BR	0	\N	-1	16c0c95b-6b04-4f57-9c5c-03c975d4daf4
1318	32	i:17,0 cm x 35,1 cm     sp:19,0 cm x 37,1 cm	pt_BR	0	\N	-1	16c0c95b-6b04-4f57-9c5c-03c975d4daf4
1319	34	Made available in DSpace on 2015-04-16T12:52:32Z (GMT). No. of bitstreams: 1\n007A5P3FG2-51.jpg: 6775478 bytes, checksum: 93a114329b86c675f5d1ba6002cd90fd (MD5)	en	0	\N	-1	16c0c95b-6b04-4f57-9c5c-03c975d4daf4
1320	59	Instituto Moreira Salles	pt_BR	0	\N	-1	16c0c95b-6b04-4f57-9c5c-03c975d4daf4
1322	61	Gilberto Ferrez	pt_BR	0	\N	-1	16c0c95b-6b04-4f57-9c5c-03c975d4daf4
1323	63	Acidente Geográfico	pt_BR	0	\N	-1	16c0c95b-6b04-4f57-9c5c-03c975d4daf4
1325	63	Horizontal	pt_BR	2	\N	-1	16c0c95b-6b04-4f57-9c5c-03c975d4daf4
1326	63	Diurna	pt_BR	3	\N	-1	16c0c95b-6b04-4f57-9c5c-03c975d4daf4
1327	63	GILBERTO FERREZ	pt_BR	4	\N	-1	16c0c95b-6b04-4f57-9c5c-03c975d4daf4
1328	63	Externa	pt_BR	5	\N	-1	16c0c95b-6b04-4f57-9c5c-03c975d4daf4
1329	70	Hospital da Beneficiência Portuguesa	pt_BR	0	\N	-1	16c0c95b-6b04-4f57-9c5c-03c975d4daf4
1330	133	Rio de Janeiro	pt_BR	0	\N	-1	16c0c95b-6b04-4f57-9c5c-03c975d4daf4
1332	133	RJ	pt_BR	2	\N	-1	16c0c95b-6b04-4f57-9c5c-03c975d4daf4
1333	133	Brasil	pt_BR	3	\N	-1	16c0c95b-6b04-4f57-9c5c-03c975d4daf4
1335	70	007A5P3FG2-51.jpg	\N	0	\N	-1	271f93fb-6f2e-4766-bc39-af649c412eb4
1336	70	THUMBNAIL	\N	1	\N	-1	db4868a4-e0d0-4d14-9f0b-aa32d6b0e8cf
1337	70	007A5P3FG2-51.jpg.jpg	\N	0	\N	-1	f25f59ff-bf38-4582-a8bb-50fef4729cc1
1338	31	https://hdl.handle.net/20.500.12156.1/2267	\N	0	\N	-1	16c0c95b-6b04-4f57-9c5c-03c975d4daf4
1339	17	2019-07-19T13:30:46Z	\N	1	\N	-1	16c0c95b-6b04-4f57-9c5c-03c975d4daf4
1340	18	2019-07-19T13:30:46Z	\N	1	\N	-1	16c0c95b-6b04-4f57-9c5c-03c975d4daf4
1341	34	Made available in DSpace on 2019-07-19T13:30:46Z (GMT). No. of bitstreams: 2\n007A5P3FG2-51.jpg: 6775478 bytes, checksum: 93a114329b86c675f5d1ba6002cd90fd (MD5)\n007A5P3FG2-51.jpg.jpg: 122374 bytes, checksum: f35567cb3879e43a8c877682faeba47d (MD5)	en	1	\N	-1	16c0c95b-6b04-4f57-9c5c-03c975d4daf4
1342	32	Generated Thumbnail	\N	0	\N	-1	f25f59ff-bf38-4582-a8bb-50fef4729cc1
\.


--
-- Name: metadatavalue_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.metadatavalue_seq', 1420, true);


--
-- Data for Name: most_recent_checksum; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.most_recent_checksum (to_be_processed, expected_checksum, current_checksum, last_process_start_date, last_process_end_date, checksum_algorithm, matched_prev_checksum, result, bitstream_id) FROM stdin;
\.


--
-- Data for Name: registrationdata; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.registrationdata (registrationdata_id, email, token, expires) FROM stdin;
\.


--
-- Name: registrationdata_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.registrationdata_seq', 1, false);


--
-- Data for Name: requestitem; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.requestitem (requestitem_id, token, allfiles, request_email, request_name, request_date, accept_request, decision_date, expires, request_message, item_id, bitstream_id) FROM stdin;
\.


--
-- Name: requestitem_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.requestitem_seq', 1, false);


--
-- Data for Name: resourcepolicy; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.resourcepolicy (policy_id, resource_type_id, resource_id, action_id, start_date, end_date, rpname, rptype, rpdescription, eperson_id, epersongroup_id, dspace_object) FROM stdin;
1	4	\N	0	\N	\N	\N	\N	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	6bbf5702-dd70-4e11-9ae9-bb1800b8f917
2	3	\N	0	\N	\N	\N	\N	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	608a1f61-7aa3-4e18-9ff9-ef7a767412c4
1181	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	17d71f15-eaf1-41da-85c3-a1ac3129ea60
3	3	\N	10	\N	\N	\N	\N	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	608a1f61-7aa3-4e18-9ff9-ef7a767412c4
4	3	\N	9	\N	\N	\N	\N	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	608a1f61-7aa3-4e18-9ff9-ef7a767412c4
1183	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	d145f27a-a203-4663-915f-7d5718fbc387
1185	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	46b7d0d6-e7be-499d-ae60-ec10bc7301f2
1187	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	608da05e-be8e-4edd-ba48-b952efd151cf
1189	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	ed372ab2-cb41-49a5-95ed-3558cdd00a13
1191	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	9f0fcbd3-5455-484e-9582-d996bbd00a4f
1193	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	a0450d8b-5720-4aca-9838-d94a779e68d6
1195	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	089f0a09-8f7b-4504-a99a-a13113cb70d7
1197	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	14704a8d-e5a9-4374-9ca5-41a0621d600c
1199	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	16e077ef-74a7-4622-8343-bbd7f22e91d6
1201	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	d91ce649-f50c-4122-8ad8-0c713d5ac137
1203	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	613ee361-f8fb-4ff5-9c55-38f0cb83be45
1205	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	e7bd4f9d-c802-498d-9aea-c3240c40233b
1207	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	d4cc7466-9447-45fe-8089-d8b8f73341a3
1209	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	a99888bf-e1c8-401b-a755-53ef7f002105
1211	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	8c0cd64c-047e-4182-98a2-b28671f7d528
35	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	d6be9004-bec3-4705-9a4e-f22796cd979e
36	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	ff09241d-855a-49c2-8fbc-45502c8b8af3
37	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	0e574c1b-c9b0-42bc-8ab0-117200a8116a
1213	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	7d29847d-6143-4a08-91f1-84ddab82f98c
38	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	9ab336a9-ac0f-4cbd-9b75-d7a9688ce99a
1215	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	1be2d800-ff0f-4727-a737-410a5f23c79a
1217	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	d172edee-f13d-4095-812e-b46560b14436
1219	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	3c2219e1-2aba-4858-b771-0da4ac35b418
1221	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	1dde7599-3b2c-49f5-ace4-51aeabf047ed
1223	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	49ad1cdd-954c-4cf1-8918-1cd7761d072a
1225	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	0648c94a-8301-46dd-81e1-b1c8720f72ca
65	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	1647a00d-03d4-484f-9747-7f10f7eb2088
66	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	a80c401c-0c0e-4822-b740-af9c3abfdf0d
67	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	5dc559b8-06ba-45a3-9924-f4edd9d834bf
68	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	0b8918a1-7938-4a16-adad-47cc659081a8
95	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	6042b9c6-0f1a-4714-863e-0208d96df43a
96	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	3b7d13a5-363f-47d1-8cd9-62916736446a
97	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	0c7568f7-0a7a-47cb-890b-45e76342b112
98	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	df393130-4c6e-4939-aa32-06db82f60c5e
125	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	4e20305a-a171-4533-bb0d-0fde80140a82
126	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	49c37abb-eb40-4511-bfa4-85b47f4f9078
127	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	2211fbd7-3a2d-429d-bae7-ecab96049a46
128	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	3f33561d-885f-4ada-bb9e-40909ce55a83
155	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	f0ea3089-84e1-4a9a-9817-16d15100fb54
156	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	105ac278-02a6-41d7-aa6b-4e0573bf2ee7
157	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	cbced2d8-7ca1-40e2-9c14-b9673c4e78ef
158	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	120ef5da-fc4e-4952-b8a8-4ffd42fc6fe9
185	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	edbc5bff-4b36-4b31-b08b-ef5b67d01a74
186	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	5a9aa0c7-bca9-4b61-acf6-087fd97eb722
187	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	a94555aa-4aab-4229-a822-94f5f8c35f2c
188	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	b77baa82-dccc-436e-b001-15055196e25e
215	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	f5487302-92d0-4914-89f6-2190c49f4ced
216	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	4d9f173b-7552-4326-ac76-a0950e387ec8
217	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	dc0680b6-5534-4091-9619-f945e80a308b
218	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	e6dd77b8-988c-415e-83c4-9e6003c237a7
245	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	b8684970-4418-4f5b-a99a-c46ed5721710
246	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	8ba24c03-9683-4bd5-8182-63a1188df55e
247	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	0107af4a-0e80-4d48-bceb-57e088cd92b0
248	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	9ba1ff9a-0530-4abb-aade-a84ee2415616
275	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	f0c85891-e655-4e8e-a6ba-eabba6fdfc97
276	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	70fdd62c-343b-4d75-b628-2040c97479e8
277	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	df126add-167e-4004-a3e0-b8b0374f885d
278	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	86832dac-4fbe-42d9-8a8d-94a9ce22cf20
305	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	af4b4244-1e85-4b33-9ca0-c267b1130df0
306	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	042e5ec3-7be3-4a30-9009-e6d3839bfda7
307	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	c168ef8c-6706-4530-8e60-0162cd97980c
308	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	9ea9f933-ee16-4dbd-889d-fdced9321c03
335	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	b17e6dc6-cd53-4646-b790-06d1a12ee1ab
336	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	4cf5e155-be37-4290-93fe-22e3edf55167
337	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	d0aa8a78-9ce7-4527-8208-35d7b34fea8d
338	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	0ced5b26-bdcf-47af-96ba-588ad0784150
365	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	3b3166f9-bb45-486b-bb08-6e2e08901cd4
366	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	611b0593-f0d8-4a0c-b694-d3143e35a3c8
367	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	001787ca-4021-4448-b6ed-6ff1d56076c0
368	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	17130f2d-bc9c-412d-9e9b-6f17d2deaaef
395	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	c82a1191-3a63-4667-bfda-6080261a4069
396	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	7423f872-ff3a-417c-b5fd-0ab44a56d884
397	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	7acced69-4137-4ae6-82aa-d425b7b12cbf
398	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	4e2f8ce5-121d-4f09-b736-953c01ffab7c
425	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	2a63b298-96d5-4ded-a0fc-e7ca3bcff831
426	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	a8361706-0b42-4805-8f75-911f1b73b298
427	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	512c54c6-fb9f-4351-a5b8-a15968510dd1
428	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	516667ff-c91e-40f5-95b5-c0905f6d9681
455	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	23356d3d-62c2-49f3-a1cd-e51531698402
456	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	9b4bc286-450d-4ddf-aa38-90b226234686
457	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	ef5c27a6-f687-441a-8947-cb07696025e3
458	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	e2c4c22c-eb00-425a-9cc1-b9240fd18311
485	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	6a7ea32d-9b1f-46c2-a002-75292eef9a8f
486	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	65710ee6-0ba1-41d7-baf4-d488222918a7
487	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	7a7c4e68-9f8e-4b25-88aa-b7642e53c76b
488	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	3a6f9fd1-ada9-4a1f-a5b9-f4ee408c36d0
515	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	e34bee2e-ff66-4fda-8ef0-a70a9cc27139
516	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	437a093f-a0eb-4947-9366-12e7cea4f579
517	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	1b96bd99-3e47-4f72-8a9c-41e3c8281bbf
518	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	f5322472-6bb0-4db5-b7c6-ff39f0f389bf
545	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	5cc3c183-a750-4b2a-8d8d-d4e4fdcc31d7
546	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	06fbd362-9e07-4867-977b-1971ef7e1812
547	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	acdc902a-8ef6-42bb-b3e0-0fcdf857d7bd
548	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	a2621d19-9ee1-4e91-b431-9c56ff0a9a95
575	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	987f4af4-d57e-4f67-b3d3-0513b13bf9f2
576	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	06956b32-551b-4839-8298-46656be0928e
577	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	d2ada78c-e4b4-44b6-ae6c-de2f19d7a6ed
578	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	317d384a-8bd7-443f-ae59-9b110bd89412
605	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	b0e86f74-1ff4-495d-827b-0d8b4f1c9d4b
606	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	f9cb7f87-a781-4b0f-8a9a-7eb5bc501b65
607	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	ef28e49e-8b42-49b5-8154-c1e13b376618
608	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	435a868d-93c3-41ec-b2d4-8ba1ff771e1f
635	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	68370f47-347b-40f5-a0bd-4cc2c6119c8e
636	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	8d8ceac0-5b32-45c2-a928-32ebf9070558
637	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	98b4567c-f60d-48a8-b40b-aa109b896617
638	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	0fd73a3a-ff0d-429c-a24e-4bc9443a54b4
665	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	65396002-d1d3-4237-83ee-52d2dc506bd5
666	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	78e9be50-f651-4538-8319-a6e2ca4c2d91
667	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	7df28185-e119-41ae-a6f0-8040cae712c8
668	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	0bb280a7-63a0-459f-8e4b-c5473e9337ab
695	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	5affab90-9b3a-4a32-aea4-15fbf5edaf17
696	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	ef47138a-4950-44d5-a967-2247a54bd4ed
697	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	9cdc3539-a776-4d24-a8c9-af225aebeaf4
698	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	22de0971-5c94-408a-b79a-784e7cca0856
725	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	7d0a10d2-1ace-4694-b908-79630b8e0b78
726	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	d5e54765-b028-4723-939d-670ae49d1292
727	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	0358ba2a-8854-4698-9435-6c8ec90af0b4
728	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	a52a46a0-92c0-43f8-9387-bbad149a9a4e
755	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	adad82ef-4c7d-4b61-b07a-4684c037320e
756	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	88d5b1c1-f0d7-49c6-adbb-36e87c268f46
757	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	60aa899d-7eba-4202-a780-6db425f03e8c
758	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	4b3a9584-97fb-4718-9534-f5028a1b99b8
785	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	2f3cc1e7-2490-427e-b00f-241dcab457a2
786	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	61b28a3c-d6b7-4bc7-b304-570a3d6ec4fb
787	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	31ad0de3-e86a-4535-9694-6f206e857d96
788	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	ffebcf7e-61b5-4acd-9cec-7919f7a1580a
815	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	09ec0ef8-ac24-4a29-a340-261df0304de8
816	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	85b21ccf-7fe9-4a85-99b8-3f14defd9024
817	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	514b31c8-3dd1-4a4b-b764-85fb7f7ab09c
818	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	a40bcc91-5bff-4767-a812-ec14e1da96b0
845	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	d6994539-a007-4084-a892-2620add43f25
846	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	8431ac09-4f3a-43c3-aa3d-1138d3e7fd28
847	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	5b5927be-37a7-4643-b553-89419b5a706d
848	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	d1e98419-e25f-4d72-a6e3-5c38a98fbc72
875	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	d3ed1b45-421a-47cf-b7a3-333df5f5599e
876	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	9a62e23b-0d7c-47c5-9882-82055f97d477
877	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	74d3fbca-f981-4a0d-a0ef-5631397f988a
878	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	8fb920ce-a656-49ff-a9b5-29f04ace2df9
905	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	51b13546-800a-44d8-81a1-f84086a43b9c
906	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	d5cdecba-6e76-4615-972e-fb7166735f0a
907	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	ad73097b-7c92-425b-9482-c1b43c3d568b
908	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	0c1c8c49-87ee-4053-b1b8-078b031a4870
935	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	4fc27f14-159f-46ec-90fe-9dfacfbd3632
936	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	408036eb-460c-44f3-823c-0f4f21b5e7d8
937	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	563eb3fb-1600-46cf-86f9-98fdafc3b478
938	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	42f9fb24-ef94-4d14-b9ce-c7fb2bb12c13
965	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	2ff5657d-1e3c-46f3-b842-37c0c6ee32e1
966	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	95248b9d-2a11-4f62-a952-f4ef8ecf6142
967	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	6b5df0be-5101-4525-b6a2-a756c86056df
968	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	eb9ff9c5-5d9d-4de5-a5ea-0fc5f40e2594
995	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	02e74364-56c7-4094-83cd-164c8db70bfb
996	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	f0be2af3-8f78-4b7e-908e-da13b7c8f998
997	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	6bc6311a-46c9-4954-b020-5ce23c722fec
998	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	1640fc10-07f2-4ac9-ad35-5ca970d7e3dc
1025	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	e729bb52-e369-4170-a38c-a011feddaedb
1026	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	9817e8d8-8eee-42b4-a188-b360ee9d1f3c
1028	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	7a1434b7-6895-4f14-a80b-c2b1205bac55
1029	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	fccef367-c66f-4c8b-b5b1-6c0c0bc26f06
1055	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	b49f6ec8-5476-4b8c-8eab-63f99a7d46b2
1056	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	a8fad082-f1f4-49f9-a73d-7df879ca8df3
1057	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	c4bd7804-502e-48f8-a12b-8b87d142393f
1058	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	ea1a91b4-37c3-4606-9f2a-bbe2e77dd621
1085	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	97b1eb6d-cf2f-41bb-8943-bb70f042485a
1086	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	cdb86a05-b0b4-497f-8808-534d330ef40f
1087	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	81d538ed-1831-40bc-827c-1b7ea43eef30
1088	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	7f71e243-6c60-4665-8f1e-cd04ea138d94
1115	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	c0b68a77-7569-45c4-a10b-2d3fca4fed29
1116	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	a7a81151-eac6-41ca-ac57-07c5f3e32100
1117	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	8baccd65-9cbb-4638-9c41-52bab8ef13c4
1118	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	18fd7b92-a579-4299-97ca-00c53e30065f
1145	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	6ef6ce81-f0f0-4345-8faa-081139d4e475
1146	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	58114c56-4af2-4df8-9ccf-11f62861190d
1147	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	ade000fc-2740-47e4-abc4-5f501ea69256
1148	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	b0af88a3-1267-44fa-a33e-e69f6652c53f
1175	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	16c0c95b-6b04-4f57-9c5c-03c975d4daf4
1176	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	2cd4b643-8b70-4e10-9ae9-6ac90e6e82ac
1177	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	271f93fb-6f2e-4766-bc39-af649c412eb4
1178	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	6f68478b-5ace-412d-838a-fd0e5c67581a	db4868a4-e0d0-4d14-9f0b-aa32d6b0e8cf
\.


--
-- Name: resourcepolicy_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.resourcepolicy_seq', 1225, true);


--
-- Data for Name: schema_version; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.schema_version (installed_rank, version, description, type, script, checksum, installed_by, installed_on, execution_time, success) FROM stdin;
1	1	<< Flyway Baseline >>	BASELINE	<< Flyway Baseline >>	\N	dspace	2019-07-19 07:40:34.658733	0	t
2	1.1	Initial DSpace 1.1 database schema	SQL	V1.1__Initial_DSpace_1.1_database_schema.sql	1147897299	dspace	2019-07-19 07:40:35.030317	323	t
3	1.2	Upgrade to DSpace 1.2 schema	SQL	V1.2__Upgrade_to_DSpace_1.2_schema.sql	903973515	dspace	2019-07-19 07:40:35.366523	64	t
4	1.3	Upgrade to DSpace 1.3 schema	SQL	V1.3__Upgrade_to_DSpace_1.3_schema.sql	-783235991	dspace	2019-07-19 07:40:35.439618	61	t
5	1.3.9	Drop constraint for DSpace 1 4 schema	JDBC	org.dspace.storage.rdbms.migration.V1_3_9__Drop_constraint_for_DSpace_1_4_schema	-1	dspace	2019-07-19 07:40:35.513013	29	t
6	1.4	Upgrade to DSpace 1.4 schema	SQL	V1.4__Upgrade_to_DSpace_1.4_schema.sql	-831219528	dspace	2019-07-19 07:40:35.558436	102	t
7	1.5	Upgrade to DSpace 1.5 schema	SQL	V1.5__Upgrade_to_DSpace_1.5_schema.sql	-1234304544	dspace	2019-07-19 07:40:35.669904	253	t
8	1.5.9	Drop constraint for DSpace 1 6 schema	JDBC	org.dspace.storage.rdbms.migration.V1_5_9__Drop_constraint_for_DSpace_1_6_schema	-1	dspace	2019-07-19 07:40:35.93303	8	t
9	1.6	Upgrade to DSpace 1.6 schema	SQL	V1.6__Upgrade_to_DSpace_1.6_schema.sql	-495469766	dspace	2019-07-19 07:40:35.951213	120	t
10	1.7	Upgrade to DSpace 1.7 schema	SQL	V1.7__Upgrade_to_DSpace_1.7_schema.sql	-589640641	dspace	2019-07-19 07:40:36.115048	19	t
11	1.8	Upgrade to DSpace 1.8 schema	SQL	V1.8__Upgrade_to_DSpace_1.8_schema.sql	-171791117	dspace	2019-07-19 07:40:36.151967	16	t
12	3.0	Upgrade to DSpace 3.x schema	SQL	V3.0__Upgrade_to_DSpace_3.x_schema.sql	-1098885663	dspace	2019-07-19 07:40:36.175323	30	t
13	4.0	Upgrade to DSpace 4.x schema	SQL	V4.0__Upgrade_to_DSpace_4.x_schema.sql	1191833374	dspace	2019-07-19 07:40:36.213207	65	t
14	4.9.2015.10.26	DS-2818 registry update	SQL	V4.9_2015.10.26__DS-2818_registry_update.sql	1675451156	dspace	2019-07-19 07:40:36.30819	11	t
15	5.0.2014.08.08	DS-1945 Helpdesk Request a Copy	SQL	V5.0_2014.08.08__DS-1945_Helpdesk_Request_a_Copy.sql	-1208221648	dspace	2019-07-19 07:40:36.329195	11	t
16	5.0.2014.09.25	DS 1582 Metadata For All Objects drop constraint	JDBC	org.dspace.storage.rdbms.migration.V5_0_2014_09_25__DS_1582_Metadata_For_All_Objects_drop_constraint	-1	dspace	2019-07-19 07:40:36.35245	10	t
17	5.0.2014.09.26	DS-1582 Metadata For All Objects	SQL	V5.0_2014.09.26__DS-1582_Metadata_For_All_Objects.sql	1509433410	dspace	2019-07-19 07:40:36.369512	33	t
18	5.6.2016.08.23	DS-3097	SQL	V5.6_2016.08.23__DS-3097.sql	410632858	dspace	2019-07-19 07:40:36.410244	3	t
19	5.7.2017.04.11	DS-3563 Index metadatavalue resource type id column	SQL	V5.7_2017.04.11__DS-3563_Index_metadatavalue_resource_type_id_column.sql	912059617	dspace	2019-07-19 07:40:36.420562	5	t
20	5.7.2017.05.05	DS 3431 Add Policies for BasicWorkflow	JDBC	org.dspace.storage.rdbms.migration.V5_7_2017_05_05__DS_3431_Add_Policies_for_BasicWorkflow	-1	dspace	2019-07-19 07:40:36.453878	172	t
21	6.0.2015.03.06	DS 2701 Dso Uuid Migration	JDBC	org.dspace.storage.rdbms.migration.V6_0_2015_03_06__DS_2701_Dso_Uuid_Migration	-1	dspace	2019-07-19 07:40:36.664914	33	t
22	6.0.2015.03.07	DS-2701 Hibernate migration	SQL	V6.0_2015.03.07__DS-2701_Hibernate_migration.sql	-542830952	dspace	2019-07-19 07:40:36.732082	337	t
23	6.0.2015.08.31	DS 2701 Hibernate Workflow Migration	JDBC	org.dspace.storage.rdbms.migration.V6_0_2015_08_31__DS_2701_Hibernate_Workflow_Migration	-1	dspace	2019-07-19 07:40:37.078424	25	t
24	6.0.2016.01.03	DS-3024	SQL	V6.0_2016.01.03__DS-3024.sql	95468273	dspace	2019-07-19 07:40:37.112546	21	t
25	6.0.2016.01.26	DS 2188 Remove DBMS Browse Tables	JDBC	org.dspace.storage.rdbms.migration.V6_0_2016_01_26__DS_2188_Remove_DBMS_Browse_Tables	-1	dspace	2019-07-19 07:40:37.142394	60	t
26	6.0.2016.02.25	DS-3004-slow-searching-as-admin	SQL	V6.0_2016.02.25__DS-3004-slow-searching-as-admin.sql	-1623115511	dspace	2019-07-19 07:40:37.211261	44	t
27	6.0.2016.04.01	DS-1955 Increase embargo reason	SQL	V6.0_2016.04.01__DS-1955_Increase_embargo_reason.sql	283892016	dspace	2019-07-19 07:40:37.280788	19	t
28	6.0.2016.04.04	DS-3086-OAI-Performance-fix	SQL	V6.0_2016.04.04__DS-3086-OAI-Performance-fix.sql	445863295	dspace	2019-07-19 07:40:37.307316	14	t
29	6.0.2016.04.14	DS-3125-fix-bundle-bitstream-delete-rights	SQL	V6.0_2016.04.14__DS-3125-fix-bundle-bitstream-delete-rights.sql	-699277527	dspace	2019-07-19 07:40:37.329647	5	t
30	6.0.2016.05.10	DS-3168-fix-requestitem item id column	SQL	V6.0_2016.05.10__DS-3168-fix-requestitem_item_id_column.sql	-1122969100	dspace	2019-07-19 07:40:37.342105	15	t
31	6.0.2016.07.21	DS-2775	SQL	V6.0_2016.07.21__DS-2775.sql	-126635374	dspace	2019-07-19 07:40:37.365942	18	t
32	6.0.2016.07.26	DS-3277 fix handle assignment	SQL	V6.0_2016.07.26__DS-3277_fix_handle_assignment.sql	-284088754	dspace	2019-07-19 07:40:37.391915	54	t
33	6.0.2016.08.23	DS-3097	SQL	V6.0_2016.08.23__DS-3097.sql	-1986377895	dspace	2019-07-19 07:40:37.481844	4	t
34	6.1.2017.01.03	DS 3431 Add Policies for BasicWorkflow	JDBC	org.dspace.storage.rdbms.migration.V6_1_2017_01_03__DS_3431_Add_Policies_for_BasicWorkflow	-1	dspace	2019-07-19 07:40:37.503455	85	t
\.


--
-- Data for Name: site; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.site (uuid) FROM stdin;
d5ff6c8f-6c64-474b-89fc-2cd0f1327c13
\.


--
-- Data for Name: subscription; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.subscription (subscription_id, eperson_id, collection_id) FROM stdin;
\.


--
-- Name: subscription_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.subscription_seq', 1, false);


--
-- Data for Name: tasklistitem; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.tasklistitem (tasklist_id, workflow_id, eperson_id) FROM stdin;
\.


--
-- Name: tasklistitem_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.tasklistitem_seq', 1, false);


--
-- Data for Name: versionhistory; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.versionhistory (versionhistory_id) FROM stdin;
\.


--
-- Name: versionhistory_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.versionhistory_seq', 1, false);


--
-- Data for Name: versionitem; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.versionitem (versionitem_id, version_number, version_date, version_summary, versionhistory_id, eperson_id, item_id) FROM stdin;
\.


--
-- Name: versionitem_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.versionitem_seq', 1, false);


--
-- Data for Name: webapp; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.webapp (webapp_id, appname, url, started, isui) FROM stdin;
1	XMLUI	http://fon-dss-dspace-imginerio-web.rice.edu:8080	2019-07-19 07:40:34.13	1
2	REST	http://fon-dss-dspace-imginerio-web.rice.edu:8080	2019-07-19 07:41:06.468	0
3	OAI	http://fon-dss-dspace-imginerio-web.rice.edu:8080	2019-07-19 07:41:32.488	0
\.


--
-- Name: webapp_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.webapp_seq', 3, true);


--
-- Data for Name: workflowitem; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.workflowitem (workflow_id, state, multiple_titles, published_before, multiple_files, item_id, collection_id, owner) FROM stdin;
\.


--
-- Name: workflowitem_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.workflowitem_seq', 1, false);


--
-- Data for Name: workspaceitem; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.workspaceitem (workspace_item_id, multiple_titles, published_before, multiple_files, stage_reached, page_reached, item_id, collection_id) FROM stdin;
\.


--
-- Name: workspaceitem_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.workspaceitem_seq', 40, true);


--
-- Name: bitstream_id_unique; Type: CONSTRAINT; Schema: public; Owner: dspace; Tablespace:
--

ALTER TABLE ONLY public.bitstream
    ADD CONSTRAINT bitstream_id_unique UNIQUE (uuid);


--
-- Name: bitstream_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace; Tablespace:
--

ALTER TABLE ONLY public.bitstream
    ADD CONSTRAINT bitstream_pkey PRIMARY KEY (uuid);


--
-- Name: bitstream_uuid_key; Type: CONSTRAINT; Schema: public; Owner: dspace; Tablespace:
--

ALTER TABLE ONLY public.bitstream
    ADD CONSTRAINT bitstream_uuid_key UNIQUE (uuid);


--
-- Name: bitstreamformatregistry_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace; Tablespace:
--

ALTER TABLE ONLY public.bitstreamformatregistry
    ADD CONSTRAINT bitstreamformatregistry_pkey PRIMARY KEY (bitstream_format_id);


--
-- Name: bitstreamformatregistry_short_description_key; Type: CONSTRAINT; Schema: public; Owner: dspace; Tablespace:
--

ALTER TABLE ONLY public.bitstreamformatregistry
    ADD CONSTRAINT bitstreamformatregistry_short_description_key UNIQUE (short_description);


--
-- Name: bundle2bitstream_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace; Tablespace:
--

ALTER TABLE ONLY public.bundle2bitstream
    ADD CONSTRAINT bundle2bitstream_pkey PRIMARY KEY (bitstream_id, bundle_id, bitstream_order);


--
-- Name: bundle_id_unique; Type: CONSTRAINT; Schema: public; Owner: dspace; Tablespace:
--

ALTER TABLE ONLY public.bundle
    ADD CONSTRAINT bundle_id_unique UNIQUE (uuid);


--
-- Name: bundle_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace; Tablespace:
--

ALTER TABLE ONLY public.bundle
    ADD CONSTRAINT bundle_pkey PRIMARY KEY (uuid);


--
-- Name: bundle_uuid_key; Type: CONSTRAINT; Schema: public; Owner: dspace; Tablespace:
--

ALTER TABLE ONLY public.bundle
    ADD CONSTRAINT bundle_uuid_key UNIQUE (uuid);


--
-- Name: checksum_history_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace; Tablespace:
--

ALTER TABLE ONLY public.checksum_history
    ADD CONSTRAINT checksum_history_pkey PRIMARY KEY (check_id);


--
-- Name: checksum_results_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace; Tablespace:
--

ALTER TABLE ONLY public.checksum_results
    ADD CONSTRAINT checksum_results_pkey PRIMARY KEY (result_code);


--
-- Name: collection2item_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace; Tablespace:
--

ALTER TABLE ONLY public.collection2item
    ADD CONSTRAINT collection2item_pkey PRIMARY KEY (collection_id, item_id);


--
-- Name: collection_id_unique; Type: CONSTRAINT; Schema: public; Owner: dspace; Tablespace:
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT collection_id_unique UNIQUE (uuid);


--
-- Name: collection_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace; Tablespace:
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT collection_pkey PRIMARY KEY (uuid);


--
-- Name: collection_uuid_key; Type: CONSTRAINT; Schema: public; Owner: dspace; Tablespace:
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT collection_uuid_key UNIQUE (uuid);


--
-- Name: community2collection_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace; Tablespace:
--

ALTER TABLE ONLY public.community2collection
    ADD CONSTRAINT community2collection_pkey PRIMARY KEY (collection_id, community_id);


--
-- Name: community2community_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace; Tablespace:
--

ALTER TABLE ONLY public.community2community
    ADD CONSTRAINT community2community_pkey PRIMARY KEY (parent_comm_id, child_comm_id);


--
-- Name: community_id_unique; Type: CONSTRAINT; Schema: public; Owner: dspace; Tablespace:
--

ALTER TABLE ONLY public.community
    ADD CONSTRAINT community_id_unique UNIQUE (uuid);


--
-- Name: community_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace; Tablespace:
--

ALTER TABLE ONLY public.community
    ADD CONSTRAINT community_pkey PRIMARY KEY (uuid);


--
-- Name: community_uuid_key; Type: CONSTRAINT; Schema: public; Owner: dspace; Tablespace:
--

ALTER TABLE ONLY public.community
    ADD CONSTRAINT community_uuid_key UNIQUE (uuid);


--
-- Name: doi_doi_key; Type: CONSTRAINT; Schema: public; Owner: dspace; Tablespace:
--

ALTER TABLE ONLY public.doi
    ADD CONSTRAINT doi_doi_key UNIQUE (doi);


--
-- Name: doi_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace; Tablespace:
--

ALTER TABLE ONLY public.doi
    ADD CONSTRAINT doi_pkey PRIMARY KEY (doi_id);


--
-- Name: dspaceobject_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace; Tablespace:
--

ALTER TABLE ONLY public.dspaceobject
    ADD CONSTRAINT dspaceobject_pkey PRIMARY KEY (uuid);


--
-- Name: eperson_email_key; Type: CONSTRAINT; Schema: public; Owner: dspace; Tablespace:
--

ALTER TABLE ONLY public.eperson
    ADD CONSTRAINT eperson_email_key UNIQUE (email);


--
-- Name: eperson_id_unique; Type: CONSTRAINT; Schema: public; Owner: dspace; Tablespace:
--

ALTER TABLE ONLY public.eperson
    ADD CONSTRAINT eperson_id_unique UNIQUE (uuid);


--
-- Name: eperson_netid_key; Type: CONSTRAINT; Schema: public; Owner: dspace; Tablespace:
--

ALTER TABLE ONLY public.eperson
    ADD CONSTRAINT eperson_netid_key UNIQUE (netid);


--
-- Name: eperson_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace; Tablespace:
--

ALTER TABLE ONLY public.eperson
    ADD CONSTRAINT eperson_pkey PRIMARY KEY (uuid);


--
-- Name: eperson_uuid_key; Type: CONSTRAINT; Schema: public; Owner: dspace; Tablespace:
--

ALTER TABLE ONLY public.eperson
    ADD CONSTRAINT eperson_uuid_key UNIQUE (uuid);


--
-- Name: epersongroup2eperson_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace; Tablespace:
--

ALTER TABLE ONLY public.epersongroup2eperson
    ADD CONSTRAINT epersongroup2eperson_pkey PRIMARY KEY (eperson_group_id, eperson_id);


--
-- Name: epersongroup2workspaceitem_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace; Tablespace:
--

ALTER TABLE ONLY public.epersongroup2workspaceitem
    ADD CONSTRAINT epersongroup2workspaceitem_pkey PRIMARY KEY (workspace_item_id, eperson_group_id);


--
-- Name: epersongroup_id_unique; Type: CONSTRAINT; Schema: public; Owner: dspace; Tablespace:
--

ALTER TABLE ONLY public.epersongroup
    ADD CONSTRAINT epersongroup_id_unique UNIQUE (uuid);


--
-- Name: epersongroup_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace; Tablespace:
--

ALTER TABLE ONLY public.epersongroup
    ADD CONSTRAINT epersongroup_pkey PRIMARY KEY (uuid);


--
-- Name: epersongroup_uuid_key; Type: CONSTRAINT; Schema: public; Owner: dspace; Tablespace:
--

ALTER TABLE ONLY public.epersongroup
    ADD CONSTRAINT epersongroup_uuid_key UNIQUE (uuid);


--
-- Name: fileextension_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace; Tablespace:
--

ALTER TABLE ONLY public.fileextension
    ADD CONSTRAINT fileextension_pkey PRIMARY KEY (file_extension_id);


--
-- Name: group2group_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace; Tablespace:
--

ALTER TABLE ONLY public.group2group
    ADD CONSTRAINT group2group_pkey PRIMARY KEY (parent_id, child_id);


--
-- Name: group2groupcache_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace; Tablespace:
--

ALTER TABLE ONLY public.group2groupcache
    ADD CONSTRAINT group2groupcache_pkey PRIMARY KEY (parent_id, child_id);


--
-- Name: handle_handle_key; Type: CONSTRAINT; Schema: public; Owner: dspace; Tablespace:
--

ALTER TABLE ONLY public.handle
    ADD CONSTRAINT handle_handle_key UNIQUE (handle);


--
-- Name: handle_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace; Tablespace:
--

ALTER TABLE ONLY public.handle
    ADD CONSTRAINT handle_pkey PRIMARY KEY (handle_id);


--
-- Name: harvested_collection_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace; Tablespace:
--

ALTER TABLE ONLY public.harvested_collection
    ADD CONSTRAINT harvested_collection_pkey PRIMARY KEY (id);


--
-- Name: harvested_item_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace; Tablespace:
--

ALTER TABLE ONLY public.harvested_item
    ADD CONSTRAINT harvested_item_pkey PRIMARY KEY (id);


--
-- Name: item2bundle_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace; Tablespace:
--

ALTER TABLE ONLY public.item2bundle
    ADD CONSTRAINT item2bundle_pkey PRIMARY KEY (bundle_id, item_id);


--
-- Name: item_id_unique; Type: CONSTRAINT; Schema: public; Owner: dspace; Tablespace:
--

ALTER TABLE ONLY public.item
    ADD CONSTRAINT item_id_unique UNIQUE (uuid);


--
-- Name: item_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace; Tablespace:
--

ALTER TABLE ONLY public.item
    ADD CONSTRAINT item_pkey PRIMARY KEY (uuid);


--
-- Name: item_uuid_key; Type: CONSTRAINT; Schema: public; Owner: dspace; Tablespace:
--

ALTER TABLE ONLY public.item
    ADD CONSTRAINT item_uuid_key UNIQUE (uuid);


--
-- Name: metadatafieldregistry_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace; Tablespace:
--

ALTER TABLE ONLY public.metadatafieldregistry
    ADD CONSTRAINT metadatafieldregistry_pkey PRIMARY KEY (metadata_field_id);


--
-- Name: metadataschemaregistry_namespace_key; Type: CONSTRAINT; Schema: public; Owner: dspace; Tablespace:
--

ALTER TABLE ONLY public.metadataschemaregistry
    ADD CONSTRAINT metadataschemaregistry_namespace_key UNIQUE (namespace);


--
-- Name: metadataschemaregistry_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace; Tablespace:
--

ALTER TABLE ONLY public.metadataschemaregistry
    ADD CONSTRAINT metadataschemaregistry_pkey PRIMARY KEY (metadata_schema_id);


--
-- Name: metadatavalue_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace; Tablespace:
--

ALTER TABLE ONLY public.metadatavalue
    ADD CONSTRAINT metadatavalue_pkey PRIMARY KEY (metadata_value_id);


--
-- Name: registrationdata_email_key; Type: CONSTRAINT; Schema: public; Owner: dspace; Tablespace:
--

ALTER TABLE ONLY public.registrationdata
    ADD CONSTRAINT registrationdata_email_key UNIQUE (email);


--
-- Name: registrationdata_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace; Tablespace:
--

ALTER TABLE ONLY public.registrationdata
    ADD CONSTRAINT registrationdata_pkey PRIMARY KEY (registrationdata_id);


--
-- Name: requestitem_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace; Tablespace:
--

ALTER TABLE ONLY public.requestitem
    ADD CONSTRAINT requestitem_pkey PRIMARY KEY (requestitem_id);


--
-- Name: requestitem_token_key; Type: CONSTRAINT; Schema: public; Owner: dspace; Tablespace:
--

ALTER TABLE ONLY public.requestitem
    ADD CONSTRAINT requestitem_token_key UNIQUE (token);


--
-- Name: resourcepolicy_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace; Tablespace:
--

ALTER TABLE ONLY public.resourcepolicy
    ADD CONSTRAINT resourcepolicy_pkey PRIMARY KEY (policy_id);


--
-- Name: schema_version_pk; Type: CONSTRAINT; Schema: public; Owner: dspace; Tablespace:
--

ALTER TABLE ONLY public.schema_version
    ADD CONSTRAINT schema_version_pk PRIMARY KEY (installed_rank);


--
-- Name: site_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace; Tablespace:
--

ALTER TABLE ONLY public.site
    ADD CONSTRAINT site_pkey PRIMARY KEY (uuid);


--
-- Name: subscription_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace; Tablespace:
--

ALTER TABLE ONLY public.subscription
    ADD CONSTRAINT subscription_pkey PRIMARY KEY (subscription_id);


--
-- Name: tasklistitem_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace; Tablespace:
--

ALTER TABLE ONLY public.tasklistitem
    ADD CONSTRAINT tasklistitem_pkey PRIMARY KEY (tasklist_id);


--
-- Name: versionhistory_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace; Tablespace:
--

ALTER TABLE ONLY public.versionhistory
    ADD CONSTRAINT versionhistory_pkey PRIMARY KEY (versionhistory_id);


--
-- Name: versionitem_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace; Tablespace:
--

ALTER TABLE ONLY public.versionitem
    ADD CONSTRAINT versionitem_pkey PRIMARY KEY (versionitem_id);


--
-- Name: webapp_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace; Tablespace:
--

ALTER TABLE ONLY public.webapp
    ADD CONSTRAINT webapp_pkey PRIMARY KEY (webapp_id);


--
-- Name: workflowitem_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace; Tablespace:
--

ALTER TABLE ONLY public.workflowitem
    ADD CONSTRAINT workflowitem_pkey PRIMARY KEY (workflow_id);


--
-- Name: workspaceitem_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace; Tablespace:
--

ALTER TABLE ONLY public.workspaceitem
    ADD CONSTRAINT workspaceitem_pkey PRIMARY KEY (workspace_item_id);


--
-- Name: bit_bitstream_fk_idx; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX bit_bitstream_fk_idx ON public.bitstream USING btree (bitstream_format_id);


--
-- Name: bitstream_id_idx; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX bitstream_id_idx ON public.bitstream USING btree (bitstream_id);


--
-- Name: bundle2bitstream_bitstream; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX bundle2bitstream_bitstream ON public.bundle2bitstream USING btree (bitstream_id);


--
-- Name: bundle2bitstream_bundle; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX bundle2bitstream_bundle ON public.bundle2bitstream USING btree (bundle_id);


--
-- Name: bundle_id_idx; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX bundle_id_idx ON public.bundle USING btree (bundle_id);


--
-- Name: bundle_primary; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX bundle_primary ON public.bundle USING btree (primary_bitstream_id);


--
-- Name: ch_result_fk_idx; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX ch_result_fk_idx ON public.checksum_history USING btree (result);


--
-- Name: checksum_history_bitstream; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX checksum_history_bitstream ON public.checksum_history USING btree (bitstream_id);


--
-- Name: collecion2item_collection; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX collecion2item_collection ON public.collection2item USING btree (collection_id);


--
-- Name: collecion2item_item; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX collecion2item_item ON public.collection2item USING btree (item_id);


--
-- Name: collection_bitstream; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX collection_bitstream ON public.collection USING btree (logo_bitstream_id);


--
-- Name: collection_id_idx; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX collection_id_idx ON public.collection USING btree (collection_id);


--
-- Name: collection_submitter; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX collection_submitter ON public.collection USING btree (submitter);


--
-- Name: collection_template; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX collection_template ON public.collection USING btree (template_item_id);


--
-- Name: collection_workflow1; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX collection_workflow1 ON public.collection USING btree (workflow_step_1);


--
-- Name: collection_workflow2; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX collection_workflow2 ON public.collection USING btree (workflow_step_2);


--
-- Name: collection_workflow3; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX collection_workflow3 ON public.collection USING btree (workflow_step_3);


--
-- Name: community2collection_collection; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX community2collection_collection ON public.community2collection USING btree (collection_id);


--
-- Name: community2collection_community; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX community2collection_community ON public.community2collection USING btree (community_id);


--
-- Name: community2community_child; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX community2community_child ON public.community2community USING btree (child_comm_id);


--
-- Name: community2community_parent; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX community2community_parent ON public.community2community USING btree (parent_comm_id);


--
-- Name: community_admin; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX community_admin ON public.community USING btree (admin);


--
-- Name: community_bitstream; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX community_bitstream ON public.community USING btree (logo_bitstream_id);


--
-- Name: community_id_idx; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX community_id_idx ON public.community USING btree (community_id);


--
-- Name: doi_doi_idx; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX doi_doi_idx ON public.doi USING btree (doi);


--
-- Name: doi_object; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX doi_object ON public.doi USING btree (dspace_object);


--
-- Name: doi_resource_id_and_type_idx; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX doi_resource_id_and_type_idx ON public.doi USING btree (resource_id, resource_type_id);


--
-- Name: eperson_email_idx; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX eperson_email_idx ON public.eperson USING btree (email);


--
-- Name: eperson_group_id_idx; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX eperson_group_id_idx ON public.epersongroup USING btree (eperson_group_id);


--
-- Name: eperson_id_idx; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX eperson_id_idx ON public.eperson USING btree (eperson_id);


--
-- Name: epersongroup2eperson_group; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX epersongroup2eperson_group ON public.epersongroup2eperson USING btree (eperson_group_id);


--
-- Name: epersongroup2eperson_person; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX epersongroup2eperson_person ON public.epersongroup2eperson USING btree (eperson_id);


--
-- Name: epersongroup2workspaceitem_group; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX epersongroup2workspaceitem_group ON public.epersongroup2workspaceitem USING btree (eperson_group_id);


--
-- Name: epersongroup_unique_idx_name; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE UNIQUE INDEX epersongroup_unique_idx_name ON public.epersongroup USING btree (name);


--
-- Name: epg2wi_workspace_fk_idx; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX epg2wi_workspace_fk_idx ON public.epersongroup2workspaceitem USING btree (workspace_item_id);


--
-- Name: fe_bitstream_fk_idx; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX fe_bitstream_fk_idx ON public.fileextension USING btree (bitstream_format_id);


--
-- Name: group2group_child; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX group2group_child ON public.group2group USING btree (child_id);


--
-- Name: group2group_parent; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX group2group_parent ON public.group2group USING btree (parent_id);


--
-- Name: group2groupcache_child; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX group2groupcache_child ON public.group2groupcache USING btree (child_id);


--
-- Name: group2groupcache_parent; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX group2groupcache_parent ON public.group2groupcache USING btree (parent_id);


--
-- Name: handle_handle_idx; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX handle_handle_idx ON public.handle USING btree (handle);


--
-- Name: handle_object; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX handle_object ON public.handle USING btree (resource_id);


--
-- Name: handle_resource_id_and_type_idx; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX handle_resource_id_and_type_idx ON public.handle USING btree (resource_legacy_id, resource_type_id);


--
-- Name: harvested_collection_collection; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX harvested_collection_collection ON public.harvested_collection USING btree (collection_id);


--
-- Name: harvested_item_item; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX harvested_item_item ON public.harvested_item USING btree (item_id);


--
-- Name: item2bundle_bundle; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX item2bundle_bundle ON public.item2bundle USING btree (bundle_id);


--
-- Name: item2bundle_item; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX item2bundle_item ON public.item2bundle USING btree (item_id);


--
-- Name: item_collection; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX item_collection ON public.item USING btree (owning_collection);


--
-- Name: item_id_idx; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX item_id_idx ON public.item USING btree (item_id);


--
-- Name: item_submitter; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX item_submitter ON public.item USING btree (submitter_id);


--
-- Name: metadatafield_schema_idx; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX metadatafield_schema_idx ON public.metadatafieldregistry USING btree (metadata_schema_id);


--
-- Name: metadatafieldregistry_idx_element_qualifier; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX metadatafieldregistry_idx_element_qualifier ON public.metadatafieldregistry USING btree (element, qualifier);


--
-- Name: metadataschemaregistry_unique_idx_short_id; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE UNIQUE INDEX metadataschemaregistry_unique_idx_short_id ON public.metadataschemaregistry USING btree (short_id);


--
-- Name: metadatavalue_field_fk_idx; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX metadatavalue_field_fk_idx ON public.metadatavalue USING btree (metadata_field_id);


--
-- Name: metadatavalue_field_object; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX metadatavalue_field_object ON public.metadatavalue USING btree (metadata_field_id, dspace_object_id);


--
-- Name: metadatavalue_object; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX metadatavalue_object ON public.metadatavalue USING btree (dspace_object_id);


--
-- Name: most_recent_checksum_bitstream; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX most_recent_checksum_bitstream ON public.most_recent_checksum USING btree (bitstream_id);


--
-- Name: mrc_result_fk_idx; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX mrc_result_fk_idx ON public.most_recent_checksum USING btree (result);


--
-- Name: requestitem_bitstream; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX requestitem_bitstream ON public.requestitem USING btree (bitstream_id);


--
-- Name: requestitem_item; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX requestitem_item ON public.requestitem USING btree (item_id);


--
-- Name: resourcepolicy_group; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX resourcepolicy_group ON public.resourcepolicy USING btree (epersongroup_id);


--
-- Name: resourcepolicy_idx_rptype; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX resourcepolicy_idx_rptype ON public.resourcepolicy USING btree (rptype);


--
-- Name: resourcepolicy_object; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX resourcepolicy_object ON public.resourcepolicy USING btree (dspace_object);


--
-- Name: resourcepolicy_person; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX resourcepolicy_person ON public.resourcepolicy USING btree (eperson_id);


--
-- Name: resourcepolicy_type_id_idx; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX resourcepolicy_type_id_idx ON public.resourcepolicy USING btree (resource_type_id, resource_id);


--
-- Name: schema_version_s_idx; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX schema_version_s_idx ON public.schema_version USING btree (success);


--
-- Name: subscription_collection; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX subscription_collection ON public.subscription USING btree (collection_id);


--
-- Name: subscription_person; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX subscription_person ON public.subscription USING btree (eperson_id);


--
-- Name: tasklist_workflow_fk_idx; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX tasklist_workflow_fk_idx ON public.tasklistitem USING btree (workflow_id);


--
-- Name: versionitem_item; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX versionitem_item ON public.versionitem USING btree (item_id);


--
-- Name: versionitem_person; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX versionitem_person ON public.versionitem USING btree (eperson_id);


--
-- Name: workspaceitem_coll; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX workspaceitem_coll ON public.workspaceitem USING btree (collection_id);


--
-- Name: workspaceitem_item; Type: INDEX; Schema: public; Owner: dspace; Tablespace:
--

CREATE INDEX workspaceitem_item ON public.workspaceitem USING btree (item_id);


--
-- Name: bitstream_bitstream_format_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.bitstream
    ADD CONSTRAINT bitstream_bitstream_format_id_fkey FOREIGN KEY (bitstream_format_id) REFERENCES public.bitstreamformatregistry(bitstream_format_id);


--
-- Name: bitstream_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.bitstream
    ADD CONSTRAINT bitstream_uuid_fkey FOREIGN KEY (uuid) REFERENCES public.dspaceobject(uuid);


--
-- Name: bundle2bitstream_bitstream_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.bundle2bitstream
    ADD CONSTRAINT bundle2bitstream_bitstream_id_fkey FOREIGN KEY (bitstream_id) REFERENCES public.bitstream(uuid);


--
-- Name: bundle2bitstream_bundle_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.bundle2bitstream
    ADD CONSTRAINT bundle2bitstream_bundle_id_fkey FOREIGN KEY (bundle_id) REFERENCES public.bundle(uuid);


--
-- Name: bundle_primary_bitstream_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.bundle
    ADD CONSTRAINT bundle_primary_bitstream_id_fkey FOREIGN KEY (primary_bitstream_id) REFERENCES public.bitstream(uuid);


--
-- Name: bundle_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.bundle
    ADD CONSTRAINT bundle_uuid_fkey FOREIGN KEY (uuid) REFERENCES public.dspaceobject(uuid);


--
-- Name: checksum_history_bitstream_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.checksum_history
    ADD CONSTRAINT checksum_history_bitstream_id_fkey FOREIGN KEY (bitstream_id) REFERENCES public.bitstream(uuid);


--
-- Name: checksum_history_result_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.checksum_history
    ADD CONSTRAINT checksum_history_result_fkey FOREIGN KEY (result) REFERENCES public.checksum_results(result_code);


--
-- Name: collection2item_collection_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.collection2item
    ADD CONSTRAINT collection2item_collection_id_fkey FOREIGN KEY (collection_id) REFERENCES public.collection(uuid);


--
-- Name: collection2item_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.collection2item
    ADD CONSTRAINT collection2item_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(uuid);


--
-- Name: collection_admin_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT collection_admin_fkey FOREIGN KEY (admin) REFERENCES public.epersongroup(uuid);


--
-- Name: collection_submitter_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT collection_submitter_fkey FOREIGN KEY (submitter) REFERENCES public.epersongroup(uuid);


--
-- Name: collection_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT collection_uuid_fkey FOREIGN KEY (uuid) REFERENCES public.dspaceobject(uuid);


--
-- Name: collection_workflow_step_1_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT collection_workflow_step_1_fkey FOREIGN KEY (workflow_step_1) REFERENCES public.epersongroup(uuid);


--
-- Name: collection_workflow_step_2_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT collection_workflow_step_2_fkey FOREIGN KEY (workflow_step_2) REFERENCES public.epersongroup(uuid);


--
-- Name: collection_workflow_step_3_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT collection_workflow_step_3_fkey FOREIGN KEY (workflow_step_3) REFERENCES public.epersongroup(uuid);


--
-- Name: community2collection_collection_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.community2collection
    ADD CONSTRAINT community2collection_collection_id_fkey FOREIGN KEY (collection_id) REFERENCES public.collection(uuid);


--
-- Name: community2collection_community_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.community2collection
    ADD CONSTRAINT community2collection_community_id_fkey FOREIGN KEY (community_id) REFERENCES public.community(uuid);


--
-- Name: community2community_child_comm_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.community2community
    ADD CONSTRAINT community2community_child_comm_id_fkey FOREIGN KEY (child_comm_id) REFERENCES public.community(uuid);


--
-- Name: community2community_parent_comm_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.community2community
    ADD CONSTRAINT community2community_parent_comm_id_fkey FOREIGN KEY (parent_comm_id) REFERENCES public.community(uuid);


--
-- Name: community_admin_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.community
    ADD CONSTRAINT community_admin_fkey FOREIGN KEY (admin) REFERENCES public.epersongroup(uuid);


--
-- Name: community_logo_bitstream_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.community
    ADD CONSTRAINT community_logo_bitstream_id_fkey FOREIGN KEY (logo_bitstream_id) REFERENCES public.bitstream(uuid);


--
-- Name: community_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.community
    ADD CONSTRAINT community_uuid_fkey FOREIGN KEY (uuid) REFERENCES public.dspaceobject(uuid);


--
-- Name: doi_dspace_object_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.doi
    ADD CONSTRAINT doi_dspace_object_fkey FOREIGN KEY (dspace_object) REFERENCES public.dspaceobject(uuid);


--
-- Name: eperson_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.eperson
    ADD CONSTRAINT eperson_uuid_fkey FOREIGN KEY (uuid) REFERENCES public.dspaceobject(uuid);


--
-- Name: epersongroup2eperson_eperson_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.epersongroup2eperson
    ADD CONSTRAINT epersongroup2eperson_eperson_group_id_fkey FOREIGN KEY (eperson_group_id) REFERENCES public.epersongroup(uuid);


--
-- Name: epersongroup2eperson_eperson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.epersongroup2eperson
    ADD CONSTRAINT epersongroup2eperson_eperson_id_fkey FOREIGN KEY (eperson_id) REFERENCES public.eperson(uuid);


--
-- Name: epersongroup2workspaceitem_eperson_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.epersongroup2workspaceitem
    ADD CONSTRAINT epersongroup2workspaceitem_eperson_group_id_fkey FOREIGN KEY (eperson_group_id) REFERENCES public.epersongroup(uuid);


--
-- Name: epersongroup2workspaceitem_workspace_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.epersongroup2workspaceitem
    ADD CONSTRAINT epersongroup2workspaceitem_workspace_item_id_fkey FOREIGN KEY (workspace_item_id) REFERENCES public.workspaceitem(workspace_item_id);


--
-- Name: epersongroup_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.epersongroup
    ADD CONSTRAINT epersongroup_uuid_fkey FOREIGN KEY (uuid) REFERENCES public.dspaceobject(uuid);


--
-- Name: fileextension_bitstream_format_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.fileextension
    ADD CONSTRAINT fileextension_bitstream_format_id_fkey FOREIGN KEY (bitstream_format_id) REFERENCES public.bitstreamformatregistry(bitstream_format_id);


--
-- Name: group2group_child_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.group2group
    ADD CONSTRAINT group2group_child_id_fkey FOREIGN KEY (child_id) REFERENCES public.epersongroup(uuid);


--
-- Name: group2group_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.group2group
    ADD CONSTRAINT group2group_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.epersongroup(uuid);


--
-- Name: group2groupcache_child_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.group2groupcache
    ADD CONSTRAINT group2groupcache_child_id_fkey FOREIGN KEY (child_id) REFERENCES public.epersongroup(uuid);


--
-- Name: group2groupcache_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.group2groupcache
    ADD CONSTRAINT group2groupcache_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.epersongroup(uuid);


--
-- Name: handle_resource_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.handle
    ADD CONSTRAINT handle_resource_id_fkey FOREIGN KEY (resource_id) REFERENCES public.dspaceobject(uuid);


--
-- Name: harvested_collection_collection_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.harvested_collection
    ADD CONSTRAINT harvested_collection_collection_id_fkey FOREIGN KEY (collection_id) REFERENCES public.collection(uuid);


--
-- Name: harvested_item_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.harvested_item
    ADD CONSTRAINT harvested_item_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(uuid);


--
-- Name: item2bundle_bundle_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.item2bundle
    ADD CONSTRAINT item2bundle_bundle_id_fkey FOREIGN KEY (bundle_id) REFERENCES public.bundle(uuid);


--
-- Name: item2bundle_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.item2bundle
    ADD CONSTRAINT item2bundle_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(uuid);


--
-- Name: item_owning_collection_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.item
    ADD CONSTRAINT item_owning_collection_fkey FOREIGN KEY (owning_collection) REFERENCES public.collection(uuid);


--
-- Name: item_submitter_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.item
    ADD CONSTRAINT item_submitter_id_fkey FOREIGN KEY (submitter_id) REFERENCES public.eperson(uuid);


--
-- Name: item_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.item
    ADD CONSTRAINT item_uuid_fkey FOREIGN KEY (uuid) REFERENCES public.dspaceobject(uuid);


--
-- Name: metadatafieldregistry_metadata_schema_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.metadatafieldregistry
    ADD CONSTRAINT metadatafieldregistry_metadata_schema_id_fkey FOREIGN KEY (metadata_schema_id) REFERENCES public.metadataschemaregistry(metadata_schema_id);


--
-- Name: metadatavalue_dspace_object_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.metadatavalue
    ADD CONSTRAINT metadatavalue_dspace_object_id_fkey FOREIGN KEY (dspace_object_id) REFERENCES public.dspaceobject(uuid) ON DELETE CASCADE;


--
-- Name: metadatavalue_metadata_field_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.metadatavalue
    ADD CONSTRAINT metadatavalue_metadata_field_id_fkey FOREIGN KEY (metadata_field_id) REFERENCES public.metadatafieldregistry(metadata_field_id);


--
-- Name: most_recent_checksum_bitstream_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.most_recent_checksum
    ADD CONSTRAINT most_recent_checksum_bitstream_id_fkey FOREIGN KEY (bitstream_id) REFERENCES public.bitstream(uuid);


--
-- Name: most_recent_checksum_result_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.most_recent_checksum
    ADD CONSTRAINT most_recent_checksum_result_fkey FOREIGN KEY (result) REFERENCES public.checksum_results(result_code);


--
-- Name: requestitem_bitstream_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.requestitem
    ADD CONSTRAINT requestitem_bitstream_id_fkey FOREIGN KEY (bitstream_id) REFERENCES public.bitstream(uuid);


--
-- Name: requestitem_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.requestitem
    ADD CONSTRAINT requestitem_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(uuid);


--
-- Name: resourcepolicy_dspace_object_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.resourcepolicy
    ADD CONSTRAINT resourcepolicy_dspace_object_fkey FOREIGN KEY (dspace_object) REFERENCES public.dspaceobject(uuid) ON DELETE CASCADE;


--
-- Name: resourcepolicy_eperson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.resourcepolicy
    ADD CONSTRAINT resourcepolicy_eperson_id_fkey FOREIGN KEY (eperson_id) REFERENCES public.eperson(uuid);


--
-- Name: resourcepolicy_epersongroup_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.resourcepolicy
    ADD CONSTRAINT resourcepolicy_epersongroup_id_fkey FOREIGN KEY (epersongroup_id) REFERENCES public.epersongroup(uuid);


--
-- Name: site_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.site
    ADD CONSTRAINT site_uuid_fkey FOREIGN KEY (uuid) REFERENCES public.dspaceobject(uuid);


--
-- Name: subscription_collection_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.subscription
    ADD CONSTRAINT subscription_collection_id_fkey FOREIGN KEY (collection_id) REFERENCES public.collection(uuid);


--
-- Name: subscription_eperson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.subscription
    ADD CONSTRAINT subscription_eperson_id_fkey FOREIGN KEY (eperson_id) REFERENCES public.eperson(uuid);


--
-- Name: tasklistitem_eperson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.tasklistitem
    ADD CONSTRAINT tasklistitem_eperson_id_fkey FOREIGN KEY (eperson_id) REFERENCES public.eperson(uuid);


--
-- Name: tasklistitem_workflow_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.tasklistitem
    ADD CONSTRAINT tasklistitem_workflow_id_fkey FOREIGN KEY (workflow_id) REFERENCES public.workflowitem(workflow_id);


--
-- Name: versionitem_eperson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.versionitem
    ADD CONSTRAINT versionitem_eperson_id_fkey FOREIGN KEY (eperson_id) REFERENCES public.eperson(uuid);


--
-- Name: versionitem_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.versionitem
    ADD CONSTRAINT versionitem_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(uuid);


--
-- Name: versionitem_versionhistory_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.versionitem
    ADD CONSTRAINT versionitem_versionhistory_id_fkey FOREIGN KEY (versionhistory_id) REFERENCES public.versionhistory(versionhistory_id);


--
-- Name: workflowitem_collection_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.workflowitem
    ADD CONSTRAINT workflowitem_collection_id_fkey FOREIGN KEY (collection_id) REFERENCES public.collection(uuid);


--
-- Name: workflowitem_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.workflowitem
    ADD CONSTRAINT workflowitem_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(uuid);


--
-- Name: workflowitem_owner_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.workflowitem
    ADD CONSTRAINT workflowitem_owner_fkey FOREIGN KEY (owner) REFERENCES public.eperson(uuid);


--
-- Name: workspaceitem_collection_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.workspaceitem
    ADD CONSTRAINT workspaceitem_collection_id_fk FOREIGN KEY (collection_id) REFERENCES public.collection(uuid);


--
-- Name: workspaceitem_collection_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.workspaceitem
    ADD CONSTRAINT workspaceitem_collection_id_fkey FOREIGN KEY (collection_id) REFERENCES public.collection(uuid);


--
-- Name: workspaceitem_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.workspaceitem
    ADD CONSTRAINT workspaceitem_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(uuid);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM dspace;
GRANT ALL ON SCHEMA public TO dspace;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--
