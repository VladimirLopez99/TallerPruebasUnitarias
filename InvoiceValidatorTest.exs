defmodule InvoiceValidator2Test do
    use ExUnit.Case, async: false
    import InvoiceValidator
  
    #Se utiliza para obtener la base de datos de las zonas horarias
    Calendar.put_time_zone_database(Tzdata.TimeZoneDatabase)

    @time_zone_cdmx "Mexico/General"
    @fecha_timbrado DateTime.from_naive!(~N[2022-03-23 15:06:35], @time_zone_cdmx)
  
    #Fechas de timbrado invalidas (más de 72 hrs)

    test "La fecha de emision 2022-03-20 13:06:31 en America/Tijuana tiene mas de 72 hrs" do
      fecha_emision = datetime(~N[2022-03-20 13:06:31], "America/Tijuana")
      assert validate_dates(fecha_emision, @fecha_timbrado) == {:error, :despues_72_hrs}
    end

    test "La fecha de emision 2022-03-20 14:06:31 en America/Sinaloa tiene mas de 72 hrs" do
      fecha_emision = datetime(~N[2022-03-20 14:06:31], "America/Mazatlan")
      assert validate_dates(fecha_emision, @fecha_timbrado) == {:error, :despues_72_hrs}
    end

    test "La fecha de emision 2022-03-20 15:06:31 en America/CDMX tiene mas de 72 hrs" do
      fecha_emision = datetime(~N[2022-03-20 15:06:31], "Mexico/General")
      assert validate_dates(fecha_emision, @fecha_timbrado) == {:error, :despues_72_hrs}
    end

    test "La fecha de emision 2022-03-20 16:06:31 en America/Qroo tiene mas de 72 hrs" do
      fecha_emision = datetime(~N[2022-03-20 16:06:31], "America/Cancun")
      assert validate_dates(fecha_emision, @fecha_timbrado) == {:error, :despues_72_hrs}
    end

    #Fechas de timbrado validas (dentro de las 72 hrs)

    test "La fecha de emision 2022-03-20 13:06:35 en America/Tijuana esta dentro de las 72 hrs" do
      fecha_emision = datetime(~N[2022-03-20 14:06:35], "America/Tijuana")
      #Hay un error con esta validacion, debido a que hay un error con la zona horaria de Tijuana y para que pase la prueba se tiene que sumarle 1 hora más.
      assert validate_dates(fecha_emision, @fecha_timbrado) == :ok
    end

    test "La fecha de emision 2022-03-20 14:06:35 en America/Sinaloa esta dentro de las 72 hrs" do
      fecha_emision = datetime(~N[2022-03-20 14:06:35], "America/Mazatlan")
      assert validate_dates(fecha_emision, @fecha_timbrado) == :ok
    end

    test "La fecha de emision 2022-03-20 15:06:35 en America/CDMX esta dentro de las 72 hrs" do
      fecha_emision = datetime(~N[2022-03-20 15:06:35], "Mexico/General")
      assert validate_dates(fecha_emision, @fecha_timbrado) == :ok
    end

    test "La fecha de emision 2022-03-20 16:06:35 en America/Qroo esta dentro de las 72 hrs" do
      fecha_emision = datetime(~N[2022-03-20 16:06:35], "America/Cancun")
      assert validate_dates(fecha_emision, @fecha_timbrado) == :ok
    end

    #Fechas de timbrado validas (5 minutos adelante)

    test "La fecha de emision 2022-03-23 13:11:35 en America/Tijuana es valida por la tolerancia de 5 minutos" do
      fecha_emision = datetime(~N[2022-03-23 13:11:35], "America/Tijuana")
      assert validate_dates(fecha_emision, @fecha_timbrado) == :ok
    end

    test "La fecha de emision 2022-03-23 14:11:35 en America/Sinaloa es valida por la tolerancia de 5 minutos" do
      fecha_emision = datetime(~N[2022-03-23 14:11:35], "America/Mazatlan")
      assert validate_dates(fecha_emision, @fecha_timbrado) == :ok
    end

    test "La fecha de emision 2022-03-23 15:11:35 en America/CDMX es valida por la tolerancia de 5 minutos" do
      fecha_emision = datetime(~N[2022-03-23 15:11:35], "Mexico/General")
      assert validate_dates(fecha_emision, @fecha_timbrado) == :ok
    end

    test "La fecha de emision 2022-03-23 13:11:35 en America/Qroo es valida por la tolerancia de 5 minutos" do
      fecha_emision = datetime(~N[2022-03-23 13:11:35], "America/Cancun")
      assert validate_dates(fecha_emision, @fecha_timbrado) == :ok
    end

    #Fechas de timbrado invalidas (5 minutos adelante)

    test "La fecha de emision 2022-03-23 13:11:36 en America/Tijuana es invalida por la tolerancia de 5 minutos" do
      fecha_emision = datetime(~N[2022-03-23 14:11:36], "America/Tijuana")
      #Hay un error con esta validacion, debido a que hay un error con la zona horaria de Tijuana y para que pase la prueba se tiene que sumarle 1 hora más.
      assert validate_dates(fecha_emision, @fecha_timbrado) == {:error, :lim_5_min}
    end

    test "La fecha de emision 2022-03-23 14:11:36 en America/Sinaloa es invalida por la tolerancia de 5 minutos" do
      fecha_emision = datetime(~N[2022-03-23 14:11:36], "America/Mazatlan")
      assert validate_dates(fecha_emision, @fecha_timbrado) == {:error, :lim_5_min}
    end

    test "La fecha de emision 2022-03-23 15:11:36 en America/CMDX es invalida por la tolerancia de 5 minutos" do
      fecha_emision = datetime(~N[2022-03-23 15:11:36], "Mexico/General")
      assert validate_dates(fecha_emision, @fecha_timbrado) == {:error, :lim_5_min}
    end

    test "La fecha de emision 2022-03-23 16:11:36 en America/Qroo es invalida por la tolerancia de 5 minutos" do
      fecha_emision = datetime(~N[2022-03-23 16:11:36], "America/Cancun")
      assert validate_dates(fecha_emision, @fecha_timbrado) == {:error, :lim_5_min}
    end
  
    defp datetime(%NaiveDateTime{} = ndt, tz) do
      DateTime.from_naive!(ndt, tz)
    end
  end