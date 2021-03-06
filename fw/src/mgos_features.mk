MGOS_ENABLE_ATCA ?= 1
MGOS_ENABLE_BITBANG ?= 1
MGOS_ENABLE_DEBUG_UDP ?= 1
MGOS_ENABLE_MDNS ?= 0
MGOS_ENABLE_FILE_UPLOAD ?= 1
MGOS_ENABLE_I2C ?= 1
MGOS_ENABLE_I2C_GPIO ?= 0
MGOS_ENABLE_ONEWIRE ?= 0
MGOS_ENABLE_SNTP ?= 1
MGOS_ENABLE_SPI ?= 1
MGOS_ENABLE_SPI_GPIO ?= 1
MGOS_ENABLE_SYS_SERVICE ?= 1
MGOS_ENABLE_UPDATER ?= 0
MGOS_ENABLE_WEB_CONFIG ?= 0
MGOS_ENABLE_WIFI ?= 1

MGOS_DEBUG_UART ?= 0
MGOS_EARLY_DEBUG_LEVEL ?= LL_INFO
MGOS_DEBUG_UART_BAUD_RATE ?= 115200
MGOS_SRCS += mgos_debug.c

MGOS_FEATURES += -DMGOS_DEBUG_UART=$(MGOS_DEBUG_UART) \
                 -DMGOS_EARLY_DEBUG_LEVEL=$(MGOS_EARLY_DEBUG_LEVEL) \
                 -DMGOS_DEBUG_UART_BAUD_RATE=$(MGOS_DEBUG_UART_BAUD_RATE) \
                 -DMG_ENABLE_CALLBACK_USERDATA

SYS_CONF_SCHEMA += $(MGOS_SRC_PATH)/mgos_http_config.yaml

ifeq "$(MGOS_ENABLE_ATCA)" "1"
  ATCA_PATH ?= $(MGOS_PATH)/third_party/cryptoauthlib
  ATCA_LIB = $(BUILD_DIR)/libatca.a

  MGOS_SRCS += mgos_atca.c
  MGOS_FEATURES += -DMGOS_ENABLE_ATCA -I$(ATCA_PATH)/lib
  SYS_CONF_SCHEMA += $(MGOS_SRC_PATH)/mgos_atca_config.yaml

$(BUILD_DIR)/atca/libatca.a:
	$(Q) mkdir -p $(BUILD_DIR)/atca
	$(Q) make -C $(ATCA_PATH)/lib \
		CC=$(CC) AR=$(AR) BUILD_DIR=$(BUILD_DIR)/atca \
	  CFLAGS="$(CFLAGS)"

$(ATCA_LIB): $(BUILD_DIR)/atca/libatca.a
	$(Q) cp $< $@
	$(Q) $(OBJCOPY) --rename-section .rodata=.irom0.text $@
	$(Q) $(OBJCOPY) --rename-section .rodata.str1.1=.irom0.text $@
else
  ATCA_LIB =
  MGOS_FEATURES += -DMGOS_ENABLE_ATCA=0
endif

ifeq "$(MGOS_ENABLE_DEBUG_UDP)" "1"
  MGOS_FEATURES += -DMGOS_ENABLE_DEBUG_UDP
  SYS_CONF_SCHEMA += $(MGOS_SRC_PATH)/mgos_debug_udp_config.yaml
endif

ifeq "$(MGOS_ENABLE_BITBANG)" "1"
  MGOS_SRCS += mgos_bitbang.c
  MGOS_FEATURES += -DMGOS_ENABLE_BITBANG
endif

ifeq "$(MGOS_ENABLE_MDNS)" "1"
  MGOS_SRCS += mgos_mdns.c
  MGOS_FEATURES += -DMG_ENABLE_DNS -DMG_ENABLE_DNS_SERVER -DMGOS_ENABLE_MDNS
endif

ifeq "$(MGOS_ENABLE_I2C)" "1"
  MGOS_SRCS += mgos_i2c.c
  MGOS_FEATURES += -DMGOS_ENABLE_I2C
  SYS_CONF_SCHEMA += $(MGOS_SRC_PATH)/mgos_i2c_config.yaml
  ifeq "$(MGOS_ENABLE_I2C_GPIO)" "1"
    MGOS_SRCS += mgos_i2c_gpio.c
    MGOS_FEATURES += -DMGOS_ENABLE_I2C_GPIO
    SYS_CONF_SCHEMA += $(MGOS_SRC_PATH)/mgos_i2c_gpio_config.yaml
  endif
endif

ifeq "$(MGOS_ENABLE_SNTP)" "1"
  MGOS_SRCS += mgos_sntp.c
  MGOS_FEATURES += -DMG_ENABLE_SNTP -DMGOS_ENABLE_SNTP
  SYS_CONF_SCHEMA += $(MGOS_SRC_PATH)/mgos_sntp_config.yaml
endif

ifeq "$(MGOS_ENABLE_SPI)" "1"
  MGOS_SRCS += mgos_spi.c
  MGOS_FEATURES += -DMGOS_ENABLE_SPI
  SYS_CONF_SCHEMA += $(MGOS_SRC_PATH)/mgos_spi_config.yaml
  ifeq "$(MGOS_ENABLE_SPI_GPIO)" "1"
    MGOS_SRCS += mgos_spi_gpio.c
    MGOS_FEATURES += -DMGOS_ENABLE_SPI_GPIO
    SYS_CONF_SCHEMA += $(MGOS_SRC_PATH)/mgos_spi_gpio_config.yaml
  endif
endif

ifeq "$(MGOS_ENABLE_UPDATER)" "1"
  SYS_CONF_SCHEMA += $(MGOS_SRC_PATH)/mgos_updater_config.yaml
  MGOS_SRCS += mgos_updater_common.c
  MGOS_FEATURES += -DMGOS_ENABLE_UPDATER
endif

ifeq "$(MGOS_ENABLE_WIFI)" "1"
  SYS_CONF_SCHEMA += $(MGOS_SRC_PATH)/mgos_wifi_config.yaml
  MGOS_SRCS += mgos_wifi.c
  MGOS_FEATURES += -DMGOS_ENABLE_WIFI
else
  MGOS_FEATURES += -DMGOS_ENABLE_WIFI=0
endif

ifeq "$(MGOS_ENABLE_WEB_CONFIG)" "1"
  MGOS_FEATURES += -DMGOS_ENABLE_WEB_CONFIG
endif

ifeq "$(MGOS_ENABLE_FILE_UPLOAD)" "1"
  MGOS_FEATURES += -DMGOS_ENABLE_FILE_UPLOAD
endif

ifeq "$(MGOS_ENABLE_ONEWIRE)" "1"
  MGOS_SRCS += mgos_onewire.c
  MGOS_FEATURES += -DMGOS_ENABLE_ONEWIRE
endif

# Export all the feature switches.
# This is required for needed make invocations (i.e. ESP32 IDF)
export MGOS_ENABLE_ATCA
export MGOS_ENABLE_BITBANG
export MGOS_ENABLE_DEBUG_UDP
export MGOS_ENABLE_I2C
export MGOS_ENABLE_I2C_GPIO
export MGOS_ENABLE_ONEWIRE
export MGOS_ENABLE_SNTP
export MGOS_ENABLE_SPI
export MGOS_ENABLE_SPI_GPIO
export MGOS_ENABLE_SYS_SERVICE
export MGOS_ENABLE_UPDATER
export MGOS_ENABLE_WIFI
