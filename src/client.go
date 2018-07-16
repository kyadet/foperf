package main

import (
	//"bufio"
	//"os"
	"strconv"
	"strings"
	"log"
	"time"
	"flag"
	"github.com/zeromq/goczmq"
	"fmt"
)

type client struct {
    Filter string
    Id int
    Seq int
    Seqgap []int
    Msg string
    Deal *goczmq.Sock
    Sub *goczmq.Sock 
    Err error
}

var msgSize = 740
var interval = 500

var (
    wakeIntval int
    recvIntval int
    destAddr string
    destDealSchema string
    destDealPort string
    destSubSchema string
    destSubPort string
    wakeCount int
    logLevel int
    fanoutRatio int
)

func param() {
    flag.IntVar(&wakeIntval, "wakeint", 1000, "wake client interval (milliseconds)")
    flag.IntVar(&recvIntval, "recvint", 500, "receive message interval (milliseconds)")
    flag.StringVar(&destAddr, "addr","127.0.0.1", "destination address")
    flag.StringVar(&destDealSchema, "dschm","tcp://", "destination dealer schema tcp or udp")
    flag.StringVar(&destDealPort, "dport",":7001", "destination dealer port")
    flag.StringVar(&destSubSchema, "sschm","tcp://", "destination subscribe schema tcp or udp")
    flag.StringVar(&destSubPort, "sport",":7000", "destination subscribe port")
    flag.IntVar(&wakeCount, "wake",5, "wake client")
    flag.IntVar(&logLevel, "log",0 ,"loglevel ... 0=lostonly, 1=verbose")
    flag.IntVar(&fanoutRatio, "ratio",0 ,"set fanout ratio, 0 is generic test start")
    flag.Parse()
}

func main() {
	param()
	interval = recvIntval
	for i := 0; i < wakeCount; i++ {
		cli := client{}
		cli.Id = i
		cli.Seq = 0
		cli.Seqgap = []int{}
		// size ... 720 * 4 bytes
		cli.Msg = "abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789"
		cli.Filter = "0"
		go Send(&cli)
		go Recv(&cli)
        	time.Sleep(time.Duration(wakeIntval) * time.Millisecond)
	}
	for {
		//reader := bufio.NewReader(os.Stdin)
		//fmt.Print(">")
		//text, _ := reader.ReadString('\n')
		//Command(text)
        	time.Sleep(0 * time.Second)
	}
}

func Command(text string){
	cmds := strings.Split(text, " ")
	if len(cmds) < 2  {
		fmt.Println("command not found")
	}
	switch cmds[0] {
		case "msgsize": SetMsgSize(cmds[1])
		case "intval": SetIntval(cmds[1])
		default: fmt.Println("command not found")
	}
}

func SetMsgSize(msg string){
	size,_ := strconv.Atoi(msg)
	if size < 2800 {
		msgSize = size
		fmt.Println("msg size reloaded "+msg)
	} else {
		fmt.Println("msg size over, size max is 2800")
	}
}

func SetIntval(msg string){
	interval,_ = strconv.Atoi(msg)
	fmt.Println("interval reloaded "+msg)
}

func Send(cli *client){
	var err error
	cli.Deal, err = goczmq.NewDealer(destDealSchema+destAddr+destDealPort)
	if err != nil {
		log.Fatal(err)
	}
	defer cli.Deal.Destroy()
	for {
		msg := strconv.Itoa(cli.Id)+","+strconv.Itoa(cli.Seq) + ","+cli.Msg[0:msgSize]
		err = cli.Deal.SendFrame([]byte(msg), goczmq.FlagNone)
		if err != nil {
		        log.Fatal(err)
		}
		if logLevel > 0 { log.Printf("<- %s", msg) }
		// else { }
		time.Sleep(time.Duration(interval) * time.Millisecond)
		cli.Seq += 1
	}
	cli.Deal.Destroy()
}

func Recv(cli *client){
	var err error
	cli.Sub, err = goczmq.NewSub(destSubSchema+destAddr+destSubPort,cli.Filter)
	cli.Sub.SetSubscribe("0")
	cli.Sub.SetSubscribe("1")
	if err != nil {
		log.Fatal(err)
	}
	defer cli.Sub.Destroy()
	for {
		reply, err := cli.Sub.RecvMessage()
		if err != nil {
		        log.Fatal(err)
		}
		if logLevel > 0 {
			log.Printf("-> %s", string(reply[0]))
		} else {
			res := strings.Split(string(reply[0]), ",")
			id := strconv.Itoa(cli.Id)
			seq := strconv.Itoa(cli.Seq)
			if id == res[1] {
				if seq == res[2] {
					//log.Printf("ok id:%d==%s seq:%s==%s",cli.Id,res[1],seq,res[2])
				} else {
					list := []int{}
					exists := false
					for losts := range cli.Seqgap {
						if losts != cli.Seq {
							list = append(list, losts)
						} else {
							exists = true
						}
					}
					if exists { list = append(list, cli.Seq) }
					cli.Seqgap = list
					//log.Printf("> self seq lost id:%s seq:%s", res[1], res[2])
					log.Printf("> delay count :%d", len(list))
				}
			} else {
				if seq == res[2] {
					//log.Printf("ok other seq:%s==%s",seq,res[2])
				} else {
					//log.Printf("> other seq lost id:%s seq:%s", res[1], res[2])
				}
			}
		}
		time.Sleep(0 * time.Second)
	}
	cli.Sub.Destroy()
}
