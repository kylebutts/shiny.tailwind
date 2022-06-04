#' Installs the tailwindcss CLI
#'
#' @param overwrite if existing installations should be overwritten
#' @param version the version to install, default is latest
#' @param verbose if the version etc should be reported
#'
#' @return the path to the tailwindcss CLI invisibly
#' @export
#'
#' @seealso [tailwindcss_compile]
#' @examples
#' if (interactive()) {
#'   install_tailwindcss_cli()
#' }
install_tailwindcss_cli <- function(overwrite = FALSE, version = "latest", verbose = FALSE) {
	if (cli_is_installed() && !overwrite)
		stop("Found existing tailwindcss installation. Abort installation!")

	info <- Sys.info()
	# 1) find system, either linux, macos, or windows
	sys <- tolower(info[["sysname"]])
	# TODO: not sure if this is catches all Mac OS?!
	if (sys == "Darwin") sys <- "macos"

	# 2) find architecture
	# TODO: does this distinguish between x64 and ARM64 in all cases?
	arch <- if (info[["machine"]] == "x86-64") "x64" else "arm64"

	file <- paste("tailwindcss",
				  if (sys == "windows") "windows-x64.exe" else
				  	paste(sys, arch, sep = "-"),
				  sep = "-")

	# 3) get latest release version
	url <- "https://github.com/tailwindlabs/tailwindcss/releases"
	if (version == "latest") {
		html <- readLines(url)
		h1 <- html[grepl("\\<h1\\>", html)][1]
		version <- gsub("^.*>([^>]+)</a>$", "\\1", h1)
	}
	if (verbose)
		cat(paste0("Trying to download tailwindcss CLI version ", version, "\n",
				   "  from ", url, "\n"))
	unlink(file)
	download_url <- paste0(url, "/download/", version, "/", file)
	suppressWarnings(a <- try(download.file(download_url, file), silent = TRUE))

	if (inherits(a, "try-error"))
		stop(sprintf(paste0(
			"Could not download tailwindcss CLI.\n",
			"  Either tailwindcss CLI version %s could not be found or another error occured.\n",
			"  Please make sure that the version is available from\n  %s"),
			version, url))

	# 4) rename file to tailwindcss(.exe)
	target <- "tailwindcss"
	if (sys == "windows") target <- paste0(target, ".exe")
	file.rename(file, target)

	cat(sprintf(paste0(
		"Success: installed tailwindcss version %s as '%s'!\n",
		"  Make sure the file is executable (chmod).\n",
		"  Feel free to move the file to your PATH.\n"), version, target))

	return(invisible(target))
}

# internal helper
get_cli_executable <- function(tailwindcss = NULL) {
	if (is.null(tailwindcss)) {
		if (Sys.info()[["sysname"]] == "Windows") {
			tailwindcss <- "tailwindcss.exe"
		} else {
			tailwindcss <- "tailwindcss"
		}
	}
	return(tailwindcss)
}


#' Checks if tailwindcss CLI is installed
#'
#' To install the CLI of tailwindcss, please follow the instructions of
#' [tailwindcss releases](https://github.com/tailwindlabs/tailwindcss/releases).
#' Make sure that you either provide the direction to the executable as the
#' first argument to this function or put it in a folder on your PATH variable.
#'
#' @param tailwindcss name and path to the executable
#' @param verbose report version number etc
#'
#' @return TRUE/FALSE
#' @export
#'
#' @examples
#' if (interactive()) {
#'   cli_is_installed()
#' }
cli_is_installed <- function(tailwindcss = NULL, verbose = FALSE) {

	tailwindcss <- get_cli_executable(tailwindcss)

	cmd <- paste(tailwindcss, "-h")
	r <- try(system(cmd, intern = TRUE), silent = TRUE)

	if (inherits(r, "try-error") || length(r) <= 2) {
		if (verbose)
			warning(paste(
				"Could not find CLI tailwindcss.",
				"Please follow install instructions and put it in your PATH or supply the path to this function",
				"Download: https://github.com/tailwindlabs/tailwindcss/releases",
				sep = "\n"
			))
		return(FALSE)
	}

	version <- gsub("tailwindcss +", "", r[[2]])
	if (verbose)
		cat(sprintf("Found tailwindcss version %s\n", version))
	return(TRUE)
}


#' Starts the tailwindcss CLI
#'
#' See also [docs](https://tailwindcss.com/blog/standalone-cli)
#'
#' @param infile the tailwindcss css file (eg containing the `@tailwind` directives)
#' @param outfile the target css file, where tailwind will write the css to
#' @param watch if the files should be continuously monitored (versus only
#'   compile the css once), default is False
#' @param tailwindcss name and path to the executable
#' @param verbose print information
#' @param minify if the code should be minified, default is FALSE
#' @param content content paths to remove unused classes, default is current dir
#'
#' @return the outfile invisibly
#' @export
#'
#' @seealso [install_tailwindcss_cli]
#' @examples
#' if (interactive()) {
#'   temp <- tempdir()
#'   owd <- setwd(temp)
#'
#'   infile <- "custom.css"
#'   writeLines("@tailwind base;", infile)
#'   outfile <- "out.css"
#'
#'   # file.copy(system.file("examples", "01-Old_Faithful", "app.R", package = "shiny.tailwind"),
#'   #           "app.R", overwrite = TRUE)
#'
#'   # write a mini shiny UI
#'   writeLines("
#'     library(shiny)
#'     div(class = \"page-div\",
#'         div(class = \"w-full text-center py-12\",
#'             h1(\"Hello World\")
#'         )
#'     )", "app.R")
#'
#'   tailwindcss <- NULL # can be set to the executable file
#'   tailwindcss_compile(infile, outfile, tailwindcss = tailwindcss)
#'   cat(paste(readLines(outfile)[1:20], collapse = "\n"))
#'
#'   setwd(owd)
#' }
tailwindcss_compile <- function(infile, outfile, watch = FALSE, minify = FALSE,
								content = ".",
								tailwindcss = NULL, verbose = FALSE) {

	stopifnot(length(infile) == 1)
	stopifnot(length(outfile) == 1)

	tailwindcss <- get_cli_executable(tailwindcss)

	if (!cli_is_installed(tailwindcss = tailwindcss))
		stop("Could not find an installation of tailwindcss!")

	conf_file <- "tailwind.config.js"
	if (!file.exists(conf_file)) {
		cat(sprintf("Could not find %s, running 'tailwindcss init'\n", conf_file))
		a <- try(system(paste(tailwindcss, "init"), intern = TRUE))
		if (inherits(a, "try-error"))
			stop("Unknown Error, could not execute 'tailwindcss init'")
	}
	# check that the content looks for R files as well!
	conf <- readLines(conf_file)
	if (any(grepl("content: \\[\\],", conf))) {
		if (verbose)
			cat(sprintf(paste("Did not find the R/Rmd content definitions in %s - adding now\n"), conf_file))

		# add the content for R and Rmd to watch
		writeLines(
			gsub("content: \\[\\]", 'content: ["./**/*.{html,js,R,Rmd}"]', conf),
			conf_file
		)
	}

	cmd <- paste(tailwindcss, "-i", infile, "-o", outfile,
				 if (watch) "--watch",
				 if (minify) "--minify",
				 if (!is.null(content) && !is.na(content)) paste("--content", content))
	system(cmd)
	return(invisible(outfile))
}
