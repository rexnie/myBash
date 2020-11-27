# export http
# source ~/bin/proxyon
proxyon() {
        # IP + PORT
        #export http_proxy="http://136.245.48.34:8000"
        # Domain name
        export http_proxy="http://cnproxy.int.xx.com/proxy.pac"

        export https_proxy=$http_proxy
        export ftp_proxy=$http_proxy
        export rsync_proxy=$http_proxy
        export no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com"
        echo -e "\nProxy environment variable set to \n"
        echo -e "$http_proxy"
}

proxyon
