report.html: report.Rmd code/f75_code2_render.R .analysis
	Rscript code/f75_code2_render.R

.analysis:
	Rscript code/f75_code1.R

.PHONY: clean
clean:
	rm -f output/*.rds && rm -f report.html