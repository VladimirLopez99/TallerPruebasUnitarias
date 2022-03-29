defmodule InvoiceValidator do

    @segundosM 60
    @segundosH 60 * @segundosM
    
    def validate_dates(%DateTime{} = fecha_emision, %DateTime{} = fecha_timbrado) do
        case DateTime.compare(fecha_emision, fecha_timbrado) do
            :eq -> :ok
            :lt -> 
                fecha_emision_no_paso = DateTime.add(fecha_emision, 72 * @segundosH, :second)
                case DateTime.compare(fecha_emision_no_paso, fecha_timbrado) do
                    :eq -> :ok
                    :gt -> :ok
                    :lt -> {:error, :despues_72_hrs}
                end
            :gt -> 
                fecha_emision_no_paso = DateTime.add(fecha_emision, -5 * @segundosM, :second)
                case DateTime.compare(fecha_emision_no_paso, fecha_timbrado) do
                    :eq -> :ok
                    :gt -> {:error, :lim_5_min}
                    :lt -> :ok
                end
        end
    end
end