package main

import (
	"fmt"
	"golang.org/x/sys/windows"
	"golang.org/x/sys/windows/registry"
	"log"
	"strings"
	"unsafe"
)

func main() {
	newPath := "C:/Program Files/Touch4win/"

	key, err := registry.OpenKey(registry.LOCAL_MACHINE, `SYSTEM\CurrentControlSet\Control\Session Manager\Environment`, registry.QUERY_VALUE|registry.SET_VALUE)
	if err != nil {
		log.Fatalf("Error al abrir la clave de registro: %v", err)
	}
	defer key.Close()

	path, _, err := key.GetStringValue("Path")
	if err != nil {
		log.Fatalf("Error al obtener el valor de PATH: %v", err)
	}

	if !strings.Contains(path, newPath) {
		updatedPath := path + ";" + newPath
		err = key.SetStringValue("Path", updatedPath)
		if err != nil {
			log.Fatalf("Error al establecer el nuevo valor de PATH: %v", err)
		}

		fmt.Println("PATH actualizado con éxito:", updatedPath)
	} else {
		fmt.Println("La ruta ya existe en PATH.")
	}

	err = notifyEnvironmentChange()
	if err != nil {
		log.Fatalf("Error al notificar el cambio de entorno: %v", err)
	}
}

func notifyEnvironmentChange() error {
	user32 := windows.NewLazySystemDLL("user32.dll")
	proc := user32.NewProc("SendMessageTimeoutW")

	ret, _, err := proc.Call(
		uintptr(0xffff),
		uintptr(0x001A),
		0,
		uintptr(unsafe.Pointer(windows.StringToUTF16Ptr("Environment"))),
		uintptr(0x0002),
		5000,
		0,
	)
	if ret == 0 {
		return err
	}
	return nil
}
