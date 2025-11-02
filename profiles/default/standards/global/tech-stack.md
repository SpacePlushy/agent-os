## Tech stack

This defines the comprehensive technical stack across all project domains: web development, embedded systems, IoT, data processing, and optimization.

### Web Development Stack

#### Frontend Framework
- **Application Framework:** Next.js 15+ (App Router)
- **Runtime:** Node.js 20+ LTS
- **Package Manager:** npm or pnpm
- **React:** React 19+ with Server Components
- **TypeScript:** Strict mode enabled
- **CSS Framework:** Tailwind CSS 4+
- **UI Components:** shadcn/ui or custom component library

#### Backend & APIs
- **API Framework:** Next.js API Routes (App Router)
- **API Design:** RESTful with OpenAPI/Swagger documentation
- **Authentication:** NextAuth.js v5+ or Auth0
- **Validation:** Zod for runtime type validation

#### Database & Storage
- **Primary Database:** PostgreSQL 15+ or Supabase
- **ORM:** Prisma or Drizzle ORM
- **Caching:** Redis or Vercel KV
- **Object Storage:** Vercel Blob or AWS S3
- **Vector Database:** Pinecone or pgvector (when needed)

#### Deployment & Infrastructure
- **Hosting:** Vercel (preferred) or self-hosted
- **CI/CD:** GitHub Actions or Vercel Git integration
- **Monitoring:** Vercel Analytics, Sentry for error tracking
- **Edge Functions:** Vercel Edge Functions for low-latency APIs

### Python Stack

#### Core Python
- **Python Version:** Python 3.11+ (3.14 preferred when stable)
- **Package Manager:** pip with requirements.txt or Poetry
- **Virtual Environments:** venv or conda
- **Type Checking:** mypy with strict type hints
- **Formatting:** black + isort
- **Linting:** ruff (replaces flake8, pylint)

#### Optimization & Operations Research
- **Constraint Programming:** Google OR-Tools CP-SAT solver
- **Linear Programming:** OR-Tools linear solver, PuLP
- **Optimization:** scipy.optimize for continuous optimization
- **Mathematical Modeling:** Python-MIP for mixed-integer programming

#### Data Processing & Analysis
- **DataFrames:** pandas for data manipulation
- **Excel Integration:** openpyxl for reading/writing Excel files
- **Excel Automation:** xlwings for advanced Excel integration
- **Data Validation:** pandera for DataFrame validation
- **Numerical Computing:** NumPy for array operations

#### IoT & Embedded Python
- **Microcontroller Framework:** MicroPython or CircuitPython
- **IoT Communication:** paho-mqtt for MQTT, requests for HTTP
- **Hardware Interface:** RPi.GPIO (Raspberry Pi), Adafruit libraries
- **Serial Communication:** pyserial for UART/serial protocols
- **Sensor Libraries:** Adafruit_CircuitPython libraries

#### Async & Concurrency
- **Async Framework:** asyncio for async/await patterns
- **HTTP Client:** httpx for async HTTP requests
- **Async Workers:** FastAPI for async web services

### Embedded Systems Stack

#### Hardware Platforms
- **Primary MCUs:** ESP32, ESP8266, STM32, Raspberry Pi Pico
- **SBCs:** Raspberry Pi 4/5, NVIDIA Jetson (for edge AI)
- **Development Boards:** Arduino (for rapid prototyping)

#### Firmware Development
- **Languages:** C/C++ for performance-critical code, MicroPython for rapid development
- **Build System:** PlatformIO or Arduino IDE with custom toolchains
- **RTOS:** FreeRTOS for real-time requirements
- **Bootloader:** Standard vendor bootloaders, custom OTA update mechanisms

#### Communication Protocols
- **Wireless:** WiFi, Bluetooth/BLE, LoRaWAN, Zigbee
- **Wired:** UART, SPI, I2C, CAN bus, Modbus
- **IoT Protocols:** MQTT, CoAP, HTTP/HTTPS

#### Debugging & Tools
- **Debugger:** JTAG/SWD with OpenOCD or vendor tools
- **Serial Monitor:** PlatformIO serial monitor, minicom
- **Logic Analyzer:** Saleae Logic or PulseView with compatible hardware

### Testing & Quality

#### Web Testing
- **Unit Testing:** Vitest or Jest
- **Integration Testing:** Playwright for E2E testing
- **Component Testing:** React Testing Library
- **API Testing:** Supertest or Playwright API testing

#### Python Testing
- **Testing Framework:** pytest with pytest-asyncio
- **Coverage:** pytest-cov for code coverage reporting
- **Mocking:** unittest.mock or pytest-mock
- **Property Testing:** hypothesis for property-based testing

#### Embedded Testing
- **Unit Testing:** Unity test framework or GoogleTest
- **Hardware-in-Loop:** Custom test harnesses with real hardware
- **Simulation:** Wokwi for ESP32/Arduino simulation

### Version Control & Collaboration
- **VCS:** Git with GitHub or GitLab
- **Branching Strategy:** Git Flow or trunk-based development
- **Commit Convention:** Conventional Commits specification
- **Code Review:** Pull requests with required reviews

### Documentation Standards
- **API Documentation:** OpenAPI 3.1 for REST APIs
- **Code Documentation:** JSDoc for TypeScript, docstrings for Python
- **Project Documentation:** Markdown in /docs folder
- **Architecture Diagrams:** Mermaid.js or draw.io
