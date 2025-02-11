# Домашнее задание к занятию «Управляющие конструкции в коде Terraform»

### Цели задания

1. Отработать основные принципы и методы работы с управляющими конструкциями Terraform.
2. Освоить работу с шаблонизатором Terraform (Interpolation Syntax).

------

### Чек-лист готовности к домашнему заданию

1. Зарегистрирован аккаунт в Yandex Cloud. Использован промокод на грант.
2. Установлен инструмент Yandex CLI.
3. Доступен исходный код для выполнения задания в директории [**03/src**](https://github.com/netology-code/ter-homeworks/tree/main/03/src).
4. Любые ВМ, использованные при выполнении задания, должны быть прерываемыми, для экономии средств.

------

### Внимание!! Обязательно предоставляем на проверку получившийся код в виде ссылки на ваш github-репозиторий!
Убедитесь что ваша версия **Terraform** ~>1.8.4
Теперь пишем красивый код, хардкод значения не допустимы!
------

### Задание 1

1. Просмотрел проект.
2. Заполнил файл personal.auto.tfvars.
3. Выполнил команды "terrafrom init" и "terraform apply". 

Примечание. Если у вас не активирован preview-доступ к функционалу «Группы безопасности» в Yandex Cloud, запросите доступ у поддержки облачного провайдера. Обычно его выдают в течение 24-х часов.

Приложите скриншот входящих правил «Группы безопасности» в ЛК Yandex Cloud или скриншот отказа в предоставлении доступа к preview-версии.

![security_groups_yandex](https://github.com/user-attachments/assets/79424ba5-a902-4ab6-a5f7-f404c755f7db)
---

------

### Задание 2

1. Создал файл count-vm.tf и описал 2 одинаковые машины web-1 и web-2 с помощью цикла count. Назначена группу безопасности из задания 1.3 (https://docs.comcloud.xyz/providers/yandex-cloud/yandex/latest/docs/resources/compute_instance).

2. Создайте файл for_each-vm.tf. Опишите в нём создание двух ВМ для баз данных с именами "main" и "replica" разных по cpu/ram/disk_volume , используя мета-аргумент for_each loop. Используйте для обеих ВМ одну общую переменную типа:

variable "each_vm" {
  type = list(object({  vm_name=string, cpu=number, ram=number, disk_volume=number }))
}

В файле for_each-vm.tf созданы машины с помощью цикла for_each, используя переменную each_vm.

![main and replica](https://github.com/user-attachments/assets/ee50ad16-c6ca-4264-bbb7-572f079196fa)
---
![main and replica yandex](https://github.com/user-attachments/assets/77e9cc74-77f1-4b30-a393-deb0243a6e39)
---


4. ВМ из пункта 2.1 должны создаваться после создания ВМ из пункта 2.2.
Использовал параметр depends_on для ВМ с web.

![depends_on](https://github.com/user-attachments/assets/b04af2ce-133a-4b7f-8184-306606da97f2)
---

5. Используйте функцию file в local-переменной для считывания ключа ~/.ssh/id_rsa.pub и его последующего использования в блоке metadata, взятому из ДЗ 2.

Применил функцию file для использования ssh ключей.

![locals for metadata](https://github.com/user-attachments/assets/5c34f3f9-9e90-44af-a949-e8339a23fbba)
---
6. Инициализируйте проект, выполните код.

Применил команды "terraform init -upgrade" и "terraform apply".

------

### Задание 3

1. Создайте 3 одинаковых виртуальных диска размером 1 Гб с помощью ресурса yandex_compute_disk и мета-аргумента count в файле **disk_vm.tf** .
В файле disk_vm.tf создал 3 виртуальных диска размером 1 Гб

![secondary disks](https://github.com/user-attachments/assets/d0e8652f-49d8-4304-8f57-ae2ab1a04db8)
---

2. Создайте в том же файле **одиночную**(использовать count или for_each запрещено из-за задания №4) ВМ c именем "storage"  . Используйте блок **dynamic secondary_disk{..}** и мета-аргумент for_each для подключения созданных вами дополнительных дисков.

![VM storage with disks](https://github.com/user-attachments/assets/6988d994-9ddc-4024-9add-db4b6498c8db)
---

![meta argument disk_vm](https://github.com/user-attachments/assets/056fd61e-5776-48ae-acbc-d2f2819a9b98)
---
------

### Задание 4

1. В файле ansible.tf создайте inventory-файл для ansible.
Используйте функцию tepmplatefile и файл-шаблон для создания ansible inventory-файла из лекции.
Готовый код возьмите из демонстрации к лекции [**demonstration2**](https://github.com/netology-code/ter-homeworks/tree/main/03/demo).
Передайте в него в качестве переменных группы виртуальных машин из задания 2.1, 2.2 и 3.2, т. е. 5 ВМ.

![ansible tf](https://github.com/user-attachments/assets/b2898a18-dc75-4f7e-9b05-0ac7ee0a87ea)
---

![hosts tftpl](https://github.com/user-attachments/assets/4a132df5-4901-4ff0-8656-b4b804c742d4)
---
В файле ansible.tf использовал функцию templatefile, отредактировал файл hosts.tftpl с ипользованием созданных ранее 5 машин. После запуска terraform init -upgrade и terraform apply добавился файл hosts.cfg*, в котором описываются все 5 ВМ.

2. Инвентарь должен содержать 3 группы и быть динамическим, т. е. обработать как группу из 2-х ВМ, так и 999 ВМ.

![after create ansible and add terraform apply](https://github.com/user-attachments/assets/871760bb-8c45-435c-896d-5e8b5746fcc1)
---

3. Добавьте в инвентарь переменную  [**fqdn**](https://cloud.yandex.ru/docs/compute/concepts/network#hostname).
``` 
[webservers]
web-1 ansible_host=<внешний ip-адрес> fqdn=<полное доменное имя виртуальной машины>
web-2 ansible_host=<внешний ip-адрес> fqdn=<полное доменное имя виртуальной машины>

[databases]
main ansible_host=<внешний ip-адрес> fqdn=<полное доменное имя виртуальной машины>
replica ansible_host<внешний ip-адрес> fqdn=<полное доменное имя виртуальной машины>

[storage]
storage ansible_host=<внешний ip-адрес> fqdn=<полное доменное имя виртуальной машины>
```
Пример fqdn: ```web1.ru-central1.internal```(в случае указания имени ВМ); ```fhm8k1oojmm5lie8i22a.auto.internal```(в случае автоматической генерации имени ВМ зона изменяется). нужную вам переменную найдите в документации провайдера или terraform console.

## Добавлена также переменная fqdn

4. Выполните код. Приложите скриншот получившегося файла. 

![hosts_сfg](https://github.com/user-attachments/assets/ff66d9b0-90e9-49d8-9bc8-102335f5a1de)
---

Для общего зачёта создайте в вашем GitHub-репозитории новую ветку terraform-03. Закоммитьте в эту ветку свой финальный код проекта, пришлите ссылку на коммит.   
**Удалите все созданные ресурсы**.

------

## Дополнительные задания (со звездочкой*)

**Настоятельно рекомендуем выполнять все задания со звёздочкой.** Они помогут глубже разобраться в материале.   
Задания со звёздочкой дополнительные, не обязательные к выполнению и никак не повлияют на получение вами зачёта по этому домашнему заданию. 

### Задание 5* (необязательное)
1. Напишите output, который отобразит ВМ из ваших ресурсов count и for_each в виде списка словарей :
``` 
[
 {
  "name" = 'имя ВМ1'
  "id"   = 'идентификатор ВМ1'
  "fqdn" = 'Внутренний FQDN ВМ1'
 },
 {
  "name" = 'имя ВМ2'
  "id"   = 'идентификатор ВМ2'
  "fqdn" = 'Внутренний FQDN ВМ2'
 },
 ....
...итд любое количество ВМ в ресурсе(те требуется итерация по ресурсам, а не хардкод) !!!!!!!!!!!!!!!!!!!!!
]
```
Приложите скриншот вывода команды ```terrafrom output```.

Добавлен файл outputs.tf для вывода данных по сложным инстансам (web и db).

![output](https://github.com/user-attachments/assets/be257965-7ffc-4979-9db1-681ec28a2add)
---

------

### Задание 6* (необязательное)

1. Используя null_resource и local-exec, примените ansible-playbook к ВМ из ansible inventory-файла.
Готовый код возьмите из демонстрации к лекции [**demonstration2**](https://github.com/netology-code/ter-homeworks/tree/main/03/demo).

## В ansible.tf добавлен способ генерации файла hosts, а также запуск playbook'а (и генерация секретов, чтобы ansible не пропускал этот шаг).

3. Модифицируйте файл-шаблон hosts.tftpl. Необходимо отредактировать переменную ```ansible_host="<внешний IP-address или внутренний IP-address если у ВМ отсутвует внешний адрес>```.

Для проверки работы уберите у ВМ внешние адреса(nat=false). Этот вариант используется при работе через bastion-сервер.
Для зачёта предоставьте код вместе с основной частью задания.

## Для проверки наличия nat убрано конкретно для storage в файле hosts.tftpl (изначальный файл переименован в hosts1.tftpl)

### Задание 7* (необязательное)
Ваш код возвращает вам следущий набор данных: 
```
> local.vpc
{
  "network_id" = "enp7i560tb28nageq0cc"
  "subnet_ids" = [
    "e9b0le401619ngf4h68n",
    "e2lbar6u8b2ftd7f5hia",
    "b0ca48coorjjq93u36pl",
    "fl8ner8rjsio6rcpcf0h",
  ]
  "subnet_zones" = [
    "ru-central1-a",
    "ru-central1-b",
    "ru-central1-c",
    "ru-central1-d",
  ]
}
```
Предложите выражение в terraform console, которое удалит из данной переменной 3 элемент из: subnet_ids и subnet_zones.(значения могут быть любыми) Образец конечного результата:
```
> <некое выражение>
{
  "network_id" = "enp7i560tb28nageq0cc"
  "subnet_ids" = [
    "e9b0le401619ngf4h68n",
    "e2lbar6u8b2ftd7f5hia",
    "fl8ner8rjsio6rcpcf0h",
  ]
  "subnet_zones" = [
    "ru-central1-a",
    "ru-central1-b",
    "ru-central1-d",
  ]
}
```

## Выражение можно использовать такое {for key, value in local.vpc: key => key == "network_id" ? value : [for index, val in value: val if index != 2]}

![local vpc](https://github.com/user-attachments/assets/2c1e6725-d605-4516-add5-3dbd3b875bbb)
---

### Критерии оценки

Зачёт ставится, если:

* выполнены все задания,
* ответы даны в развёрнутой форме,
* приложены соответствующие скриншоты и файлы проекта,
* в выполненных заданиях нет противоречий и нарушения логики.

На доработку работу отправят, если:

* задание выполнено частично или не выполнено вообще,
* в логике выполнения заданий есть противоречия и существенные недостатки. 
