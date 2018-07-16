package main

import (
	"log"
	"time"
	"flag"
	"github.com/zeromq/goczmq"
	"strings"
	"strconv"
)

var (
    destDealSchema string
    destDealPort string
    destSubSchema string
    destSubPort string
    logLevel int
)
func param() {
    flag.StringVar(&destDealSchema, "dschm","tcp://", "destination dealer schema tcp or udp")
    flag.StringVar(&destDealPort, "dport",":7001", "destination dealer port")
    flag.StringVar(&destSubSchema, "sschm","tcp://", "destination subscribe schema tcp or udp")
    flag.StringVar(&destSubPort, "sport",":7000", "destination subscribe port")
    flag.IntVar(&logLevel, "log",0 ,"loglevel ... 0=lostonly, 1=verbose")
    flag.Parse()
}

func main() {
	param()
	router, err := goczmq.NewRouter(destDealSchema+"*"+destDealPort)
	if err != nil {
		log.Fatal(err)
	}
	defer router.Destroy()

        pub, err := goczmq.NewPub(destSubSchema+"*"+destSubPort)
        if err != nil {
                log.Fatal(err)
        }
        defer pub.Destroy()
    for {
	request, err := router.RecvMessage()
	if err != nil {
		log.Fatal(err)
	}
	//log.Printf("router received '%s' from '%v'", request[1], request[0])
	if logLevel > 0 { 
		log.Printf("-> %s", request[1])
	}
	
	err = pub.SendFrame([]byte("0,"+string(request[1])), goczmq.FlagNone)
        if err != nil {
                log.Fatal(err)
        }

        time.Sleep(0 * time.Second) // return context
    }
}
