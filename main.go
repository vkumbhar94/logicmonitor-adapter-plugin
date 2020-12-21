package main

import (
	"fmt"
	"io/ioutil"
	"path/filepath"

	"strings"
	"time"

	"github.com/vkumbhar94/kube-metrics-adapter-client/pkg/collector"
	autoscalingv2 "k8s.io/api/autoscaling/v2beta2"
)

func main() {
	fmt.Println("vim-go")
	files, err := ioutil.ReadDir("./")
	if err != nil {
		return
		//log.Fatal(err)
	}

	for _, f := range files {
		if strings.HasSuffix(f.Name(), ".so") {
			nm := strings.TrimSuffix(f.Name(), filepath.Ext(f.Name()))

			fmt.Println(nm)
			fmt.Println(f.Name())
		}
	}
}

// NewCollectorPlugin initializes collecror plugin
func NewCollectorPlugin() {
	fmt.Println("Call received to new collector plugin")

}

type LogicmontorCollectorPlugin struct {
	nm string
}

func (lmcp *LogicmontorCollectorPlugin) NewCollector(hpa *autoscalingv2.HorizontalPodAutoscaler, config *collector.MetricConfig, interval time.Duration) (*LogicmontorCollectorPlugin, error) {
	fmt.Println("Received to LM Plugin NewCollector: %v %v %v ", hpa, config, interval)
	return nil, nil
}
