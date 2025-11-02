## Embedded firmware best practices

### Hardware Platforms

- **ESP32/ESP8266**: Preferred for WiFi/Bluetooth IoT projects; excellent ecosystem and community
- **STM32**: Use for performance-critical applications requiring real-time control
- **Raspberry Pi Pico**: Cost-effective for simpler projects; RP2040 has great PIO capabilities
- **Arduino**: Acceptable for rapid prototyping; migrate to native toolchain for production
- **Platform Selection**: Choose based on: power requirements, connectivity needs, processing power, cost, availability

### Development Environment

- **PlatformIO**: Preferred IDE; superior to Arduino IDE for professional development
- **VSCode + PlatformIO**: Standard development environment; leverages IntelliSense and debugging
- **Version Control**: Track all firmware code, configurations, and build scripts in Git
- **Build Reproducibility**: Pin library versions in `platformio.ini`; document toolchain versions
- **Serial Monitor**: Use PlatformIO serial monitor; configure correct baud rate (typically 115200)

### Code Organization

- **Modular Architecture**: Separate concerns (hardware abstraction, business logic, communication)
- **Hardware Abstraction Layer (HAL)**: Abstract hardware-specific code for portability
- **State Machines**: Use explicit state machines for complex device behavior
- **Configuration Header**: Centralize pin definitions, constants, and settings in `config.h`
- **Minimal main()**: Keep `setup()` and `loop()` minimal; delegate to well-named functions

### Memory Management

- **Stack vs Heap**: Prefer stack allocation; minimize or avoid heap (`malloc`/`new`)
- **Static Memory**: Use static buffers for known-size data; safer than dynamic allocation
- **Memory Monitoring**: Regularly check free heap and stack usage; log in development
- **String Handling**: Avoid `String` class on resource-constrained devices; use `char[]` or `const char*`
- **Buffer Sizes**: Define buffer sizes as constants; add overflow protection
- **PROGMEM**: Store constants in flash (`PROGMEM`) instead of RAM when possible

### Power Management

- **Sleep Modes**: Use deep sleep for battery-powered devices; wake on timer or interrupt
- **Power Budgeting**: Calculate power consumption for all components; size battery appropriately
- **Peripheral Shutdown**: Disable unused peripherals (ADC, WiFi, Bluetooth) when not needed
- **Low-Power Libraries**: Use low-power libraries and modes for MCU-specific features
- **Voltage Monitoring**: Monitor battery voltage; implement low-battery handling

### Real-Time Considerations

- **Interrupt Service Routines (ISRs)**: Keep ISRs minimal; set flags, don't process
- **IRAM_ATTR**: Mark time-critical functions with `IRAM_ATTR` on ESP32 to run from RAM
- **Volatile Variables**: Use `volatile` for variables modified in ISRs
- **Timing**: Use `millis()` or hardware timers; avoid `delay()` except for short waits
- **RTOS**: Use FreeRTOS for complex multitasking; ESP32 includes it by default
- **Task Priorities**: Set appropriate FreeRTOS task priorities; higher priority for time-critical tasks

### Communication Protocols

#### Serial (UART)
- **Baud Rate**: Use standard rates (9600, 115200); document in code and README
- **Data Format**: Define packet structure; use delimiters or length prefixes
- **Error Checking**: Implement checksums (CRC, simple sum) for data integrity
- **Timeout Handling**: Set receive timeouts; don't block indefinitely

#### I2C
- **Pull-ups**: Ensure proper pull-up resistors (typically 4.7k© for 100kHz)
- **Address Conflicts**: Document I2C addresses; check for conflicts with datasheets
- **Clock Speed**: Use 100kHz (standard) unless all devices support 400kHz (fast mode)
- **Error Handling**: Handle NACK and bus errors gracefully

#### SPI
- **Clock Polarity**: Verify CPOL/CPHA settings match slave device requirements
- **Chip Select**: Manage CS pins explicitly; don't leave floating
- **Clock Speed**: Start conservative (1MHz); increase if devices support and timing is verified
- **Multi-Slave**: Use separate CS pins for each slave; never share

### WiFi & Networking (ESP32/ESP8266)

- **Connection Management**: Implement reconnection logic with exponential backoff
- **WiFi Credentials**: Store in NVS or EEPROM; never hardcode production credentials
- **HTTPS**: Use HTTPS for secure communication; pin certificates when possible
- **NTP Time Sync**: Synchronize time with NTP for logging and timestamps
- **mDNS**: Use mDNS for device discovery on local network
- **Connection State**: Track and log WiFi connection state; handle disconnections gracefully

### Debugging & Logging

- **Serial Logging**: Use Serial.print() for development; implement log levels (DEBUG, INFO, ERROR)
- **Conditional Compilation**: Use `#ifdef DEBUG` to remove debug code in production builds
- **Watchdog Timer**: Implement watchdog timer to recover from hangs; reset if loop() takes too long
- **Error Codes**: Define error codes for common failures; log with context
- **LED Indicators**: Use LEDs to indicate states (connecting, connected, error)
- **Remote Logging**: Send critical errors over network to monitoring system

### Over-The-Air (OTA) Updates

- **OTA Support**: Implement OTA updates for field-deployed devices
- **Version Checking**: Check firmware version before update; prevent downgrades
- **Rollback**: Implement rollback on failed update; use dual partition scheme (ESP32)
- **Update Security**: Verify firmware signature before flashing; use encrypted updates
- **Update UI**: Provide feedback during update; never interrupt power during flash

### Security

- **Secure Boot**: Enable secure boot on supported platforms (ESP32) for production
- **Flash Encryption**: Encrypt flash storage for sensitive data
- **Certificate Pinning**: Pin server certificates for HTTPS connections
- **API Keys**: Store API keys in secure NVS; encrypt when possible
- **Physical Security**: Consider tamper detection for high-security applications
- **Least Privilege**: Minimize permissions; don't run everything as admin/root

### Testing

- **Unit Testing**: Use native environment in PlatformIO for unit tests; test business logic
- **Hardware-in-Loop**: Test with actual hardware; simulate sensors when needed
- **Boundary Conditions**: Test edge cases (power loss, network loss, sensor failures)
- **Endurance Testing**: Run for extended periods; verify no memory leaks or crashes
- **Environmental Testing**: Test in target temperature/humidity range if critical

### Performance Optimization

- **Profile First**: Measure before optimizing; identify actual bottlenecks
- **Lookup Tables**: Use lookup tables instead of calculations for frequently accessed data
- **Integer Math**: Use integer arithmetic instead of floating point when possible
- **Bitwise Operations**: Use bitwise operations for flags and bit manipulation
- **Inline Functions**: Mark frequently called small functions as `inline`
- **Compiler Optimization**: Enable appropriate optimization level (`-O2`, `-Os`)

### Code Quality

- **Const Correctness**: Use `const` for read-only variables and function parameters
- **Magic Numbers**: Define as named constants or enums
- **Error Handling**: Check return values from library functions; handle errors explicitly
- **Initialization**: Initialize all variables; uninitialized memory causes hard-to-debug issues
- **Comments**: Document non-obvious hardware behavior, timing requirements, and workarounds
- **Code Reviews**: Review all firmware changes; embedded bugs are expensive to fix post-deployment

### Common Pitfalls

- **Blocking Code**: Avoid long-running operations in loop(); breaks WiFi and other background tasks
- **Delay Abuse**: Don't use `delay()` for timing; use non-blocking patterns with `millis()`
- **Stack Overflow**: Monitor stack usage; recursive functions can overflow limited stack
- **Integer Overflow**: Check for overflow in calculations; use larger types when needed
- **Floating Point**: Avoid on MCUs without FPU; use fixed-point arithmetic
- **Global Overuse**: Minimize global variables; pass data explicitly when possible
- **Watchdog Disabled**: Always keep watchdog enabled; last line of defense against hangs

### Documentation Requirements

- **Pinout Diagram**: Document pin connections and assignments
- **Hardware Version**: Track hardware revision; firmware may need to support multiple versions
- **Dependency List**: List required libraries with versions
- **Build Instructions**: Document build process, toolchain setup, and flashing procedure
- **Configuration**: Document all configurable parameters and their defaults
- **Power Requirements**: Document voltage and current requirements
- **Communication Protocols**: Specify baud rates, packet formats, and timing requirements

### Deployment Checklist

- [ ] Debug logging disabled or reduced in production builds
- [ ] Watchdog timer enabled
- [ ] OTA update mechanism tested
- [ ] Error handling covers all critical paths
- [ ] Power consumption measured and acceptable
- [ ] Network reconnection logic tested
- [ ] Firmware version number incremented
- [ ] Hardware compatibility verified
- [ ] Security features enabled (if applicable)
- [ ] Documentation updated
