#' Installs the 'TailwindCSS' CLI
#'
#' @description This will download the 'TailwindCSS' standalone CLI to the
#' current working directory.
#'
#' @details This will download the 'TailwindCSS' standalone CLI to the current
#'   working directory.
#'   See [here](https://tailwindcss.com/blog/standalone-cli) for details on the
#'   standalone CLI. This saves you from having to install 'node.js'.
#'
#'   On the mac, after installing the CLI, you need to make sure that the file
#'   is executable to run it. For Mac, the easiest way to do so is to ensure
#'   you're in the correct working directory in R and type
#'   `system("chmod +x tailwindcss")`.
#'   Alternatively, you could `cd` to the directory in terminal and then run
#'   `chmod +x tailwindcss`.
#'
#'
#' @param overwrite if existing installations should be overwritten
#' @param version the version to install, default is latest
#' @param verbose if the version etc should be reported
#'
#' @export
#' @return invisibly the path to the cli program
#'
#' @seealso [compile_tailwindcss]
#' @examples
#' if(interactive()) {
#'   install_tailwindcss_cli()
#' }
install_tailwindcss_cli <- function(overwrite = FALSE, version = "latest", verbose = FALSE) {
  if(is_tailwindcss_installed() && !overwrite) {
    stop("Found existing tailwindcss installation. Abort installation!")
  }

  info <- Sys.info()
  # 1) find system, either linux, macos, or windows
  sys <- tolower(info[["sysname"]])
  # TODO: not sure if this is catches all Mac OS?!
  if(sys == "darwin") sys <- "macos"

  # 2) find architecture
  # TODO: does this distinguish between x64 and ARM64 in all cases?
  arch <- if(grepl("x86.64", info[["machine"]])) "x64" else "arm64"

  file <- paste("tailwindcss",
    if(sys == "windows") {
      "windows-x64.exe"
    } else {
      paste(sys, arch, sep = "-")
    },
    sep = "-"
  )

  # 3) get latest release version
  url <- "https://github.com/tailwindlabs/tailwindcss/releases"
  if(version == "latest") {
    html <- readLines(url)
    # Returns all available versions
    v <- grep(".*\\>(v[0-9]+.[0-9]+.[0-9]+)\\<.*", value = TRUE, html, perl = TRUE)
    # Extract release version
    version <- regmatches(v, gregexec("v[0-9]+.[0-9]+.[0-9]+", v))[[1]][1,1]

  }
  if(verbose) {
    cat(paste0(
      "Trying to download tailwindcss CLI version ", version, "\n",
      "  from ", url, "\n"
    ))
  }
  unlink(file)
  download_url <- paste0(url, "/download/", version, "/", file)
  suppressWarnings({
    a <- try(utils::download.file(download_url, file), silent = TRUE)
  })

  if(inherits(a, "try-error")) {
    stop(sprintf(
      paste0(
        "Could not download tailwindcss CLI.\n",
        "  Either tailwindcss CLI version %s could not be found or another error occured.\n",
        "  Please make sure that the version is available from\n  %s"
      ),
      version, url
    ))
  }

  # 4) rename file to tailwindcss(.exe)
  target <- "tailwindcss"
  if(sys == "windows") target <- paste0(target, ".exe")
  file.rename(file, target)

  if(sys == "macos") system("chmod +x tailwindcss")

  cat(sprintf(paste0(
    "Success: installed tailwindcss version %s as '%s'!\n",
    "Next you must ensure that the tailwind css file is executable.\n",
    "Type `?install_tailwindcss_cli` to read more about how to do this"
  ), version, target))

  return(invisible(target))
}

# internal helper
get_cli_executable <- function(tailwindcss = NULL) {
  if(is.null(tailwindcss)) {
    if(Sys.info()[["sysname"]] == "Windows") {
      tailwindcss <- "tailwindcss.exe"
    } else {
      tailwindcss <- "./tailwindcss"
    }
  }
  return(tailwindcss)
}


#' Checks if 'TailwindCSS' CLI is installed
#'
#' To install the CLI of 'TailwindCSS', please follow the instructions of
#' ['TailwindCSS' releases](https://github.com/tailwindlabs/tailwindcss/releases).
#' Make sure that you either provide the direction to the executable as the
#' first argument to this function or put it in a folder on your PATH variable.
#'
#' @param tailwindcss name and path to the executable
#' @param verbose report version number etc
#'
#' @return TRUE/FALSE if the CLI is installed
#' @export
#'
#' @examples
#' if(interactive()) {
#'   is_tailwindcss_installed()
#' }
is_tailwindcss_installed <- function(tailwindcss = NULL, verbose = FALSE) {
  tailwindcss <- get_cli_executable(tailwindcss)

  cmd <- paste(tailwindcss, "-h")
  r <- try(system(cmd, intern = TRUE), silent = TRUE)

  if(inherits(r, "try-error") || length(r) <= 2) {
    if(verbose) {
      warning(paste(
        "Could not find CLI tailwindcss.",
        "Please follow install instructions and put it in your PATH or supply the path to this function",
        "Download: https://github.com/tailwindlabs/tailwindcss/releases",
        attr(r, "condition"),
        sep = "\n"
      ))
    }
    return(FALSE)
  }

  version <- gsub("tailwindcss +", "", r[[2]])
  if(verbose) {
    cat(sprintf("Found tailwindcss version %s\n", version))
  }
  return(TRUE)
}


#' Starts the 'TailwindCSS' CLI
#'
#' See also [tailwind docs](https://tailwindcss.com/blog/standalone-cli)
#'
#' @param infile the 'TailwindCSS' file (eg containing the `@tailwind` directives). Relative to basedir
#' @param outfile the target css file, where tailwind will write the css to.
#'   Relative to basedir
#' @param config the path to the tailwind.config.js file Default: tailwind.config.js in the root diretory
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
#' if(interactive()) {
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
#'   compile_tailwindcss(infile, outfile, tailwindcss = tailwindcss)
#'   cat(paste(readLines(outfile)[1:20], collapse = "\n"))
#'
#'   setwd(owd)
#' }
compile_tailwindcss <- function(infile,
                                outfile,
                                config = "tailwind.config.js",
                                watch = FALSE,
                                minify = FALSE,
                                content = ".",
                                tailwindcss = NULL,
                                verbose = FALSE) {
  stopifnot(length(infile) == 1)
  stopifnot(length(outfile) == 1)

  if(!is_tailwindcss_installed(tailwindcss = tailwindcss)) {
    stop("Could not find an installation of tailwindcss!")
  }
  tailwindcss <- get_cli_executable(tailwindcss)


  # Create config if there is none
  if(!file.exists(config)) {
    cat(sprintf(
      "Could not find %s, copying default from shiny.tailwind\n",
      config
    ))

    file.copy(
      system.file("default-tailwind.config.js", package = "shiny.tailwind"),
      config
    )
  }

  cmd <- paste(
    tailwindcss, "--config", config,
    "--input", infile, "--output", outfile,
    if(watch) "--watch",
    if(minify) "--minify"
  )
  if(verbose) cat(paste0("Running tailwindcss CLI command:\n  ", cmd))
  a <- try(system(cmd, intern = TRUE), silent = TRUE)
  if(inherits(a, "try-error")) {
    cat(gsub("\\\\r\\\\n", "\n", a))
    stop("Could not execute tailwindcss CLI with error\n", a)
  }

  return()
}
