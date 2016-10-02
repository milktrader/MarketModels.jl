function dev()
    gen_op(CAT)
    c   = @select CAT where Close;
    ret = percentchange(c)
end
