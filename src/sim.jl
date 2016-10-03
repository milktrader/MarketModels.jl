function simulate(a::Array)
    current_price = 100
    returns_arr   = Float64[]
    for f in a
        current_price = current_price * f + current_price
        push!(returns_arr, current_price)
    end
    returns_arr
end
