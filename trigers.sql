CREATE OR REPLACE FUNCTION add_to_his_order() RETURNS TRIGGER AS $$
DECLARE
    sbol BOOLEAN;
	mint BIGINT;
BEGIN
    IF    TG_OP = 'INSERT' THEN
        sbol = NEW.status;
		mint = NEW.id;
        INSERT INTO history_status_order(last_status_order,id_order) values (sbol,mint);
        RETURN NEW;
    ELSIF TG_OP = 'UPDATE' THEN
        sbol = NEW.status;
		mint = NEW.id;
        INSERT INTO history_status_order(last_status_order,id_order) values (sbol,mint);
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
         sbol = OLD.status;
		 mint = OLD.id;
        INSERT INTO history_status_order(last_status_order,id_order) values (sbol,mint);
        RETURN OLD;
    END IF;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER t_order_item
AFTER INSERT OR UPDATE OR DELETE ON order_item FOR EACH ROW EXECUTE PROCEDURE add_to_his_order();



CREATE OR REPLACE FUNCTION add_to_his_area() RETURNS TRIGGER AS $$
BEGIN
    IF    TG_OP = 'INSERT'  THEN
		IF    NEW.status  THEN
			UPDATE storage_area SET size_storage = size_storage - NEW.count_palets  WHERE id = NEW.id_storage_area;

		END IF;
	RETURN NEW;
    END IF;
	IF    TG_OP = 'UPDATE'  THEN
		IF    NEW.status == false  THEN
			UPDATE storage_area SET size_storage = size_storage + NEW.count_palets  WHERE id = NEW.id_storage_area;

		END IF;
	RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE TRIGGER t_order_item_to_storage
AFTER INSERT OR UPDATE OR DELETE ON order_item FOR EACH ROW EXECUTE PROCEDURE add_to_his_area();


CREATE OR REPLACE FUNCTION add_to_refund() RETURNS TRIGGER AS $$
DECLARE
    sbol varchar(30);
	mid BIGINT;
BEGIN
    IF    TG_OP = 'INSERT' OR TG_OP = 'UPDATE'  THEN
		IF NEW.status = 'false' AND NEW.brak ='false' THEN
			sbol = 'Vozvrat';
			mid = NEW.id;
			INSERT INTO refund(reazon,create_date,id_order) values (sbol,CURRENT_TIMESTAMP, mid);
			RETURN NEW;
		ELSIF NEW.brak THEN
			sbol = 'brak';
			mid = NEW.id;
			INSERT INTO refund(reazon,create_date,id_order) values (sbol,CURRENT_TIMESTAMP, mid);
			RETURN NEW;
		END IF;
		RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;

 CREATE TRIGGER t_order_item_to_refund
 AFTER INSERT OR UPDATE ON order_item FOR EACH ROW EXECUTE PROCEDURE add_to_refund();



CREATE OR REPLACE FUNCTION notify_option() RETURNS TRIGGER AS $$
BEGIN
    IF    TG_OP = 'UPDATE'  THEN
		IF    NEW.current_size > NEW.min_size
		THEN
			INSERT INTO notify(date_notify,reazon) values (CURRENT_TIMESTAMP,concat('nexvatka tovara in ', NEW.place_store,' polka - ', NEW.polka, ' na pozition - ',NEW.posizion));

		END IF;
	RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER t_locale_store_notify_option
AFTER UPDATE ON locale_store FOR EACH ROW EXECUTE PROCEDURE notify_option();


CREATE OR REPLACE FUNCTION inventory_option() RETURNS TRIGGER AS $$
BEGIN
IF    TG_OP = 'INSERT'  THEN
			UPDATE locale_store SET current_size = NEW.count_product * NEW.size_product  WHERE id = NEW.id_locale_store;
	RETURN NEW;
	ELSIF TG_OP = 'UPDATE' THEN
        UPDATE locale_store SET current_size = NEW.count_product * NEW.size_product  WHERE id = NEW.id_locale_store;
    RETURN NEW;

    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER t_inventory_option
AFTER INSERT OR UPDATE ON inventory FOR EACH ROW EXECUTE PROCEDURE inventory_option();


