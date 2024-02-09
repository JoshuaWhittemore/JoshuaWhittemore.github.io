# This file was generated, do not modify it. # hide
#import ZipFile
#
#zarchive = ZipFile.Reader(zippath)
#
#for f in zarchive.files
#  println(f.name)
#  fpath = joinpath("../input/", f.name)
#  write(fpath, read(f, String))
#end
#
#close(zarchive)