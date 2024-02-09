# This file was generated, do not modify it. # hide
round.(GLM.predict(model, df_new, level=0.95, interval=:prediction), digits=5)