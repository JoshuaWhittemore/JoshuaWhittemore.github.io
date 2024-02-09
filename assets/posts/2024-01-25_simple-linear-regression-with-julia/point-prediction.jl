# This file was generated, do not modify it. # hide
df_new = DataFrame(x_acidity = [7.0])

print(round.(df_new.x_acidity .* β̂ .+ α̂, digits=5))
print(round.(GLM.predict(model, df_new), digits=5))