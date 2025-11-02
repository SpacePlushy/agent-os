## API endpoint standards and conventions

### RESTful Design Principles

- **RESTful Design**: Follow REST principles with clear resource-based URLs and appropriate HTTP methods (GET, POST, PUT, PATCH, DELETE)
- **Resource-Based URLs**: Use nouns for resources, not verbs (`/users` not `/getUsers`)
- **HTTP Methods**: GET (read), POST (create), PUT (full update), PATCH (partial update), DELETE (remove)
- **Stateless**: Each request contains all information needed; don't rely on server-side session state for API auth
- **Idempotency**: GET, PUT, PATCH, DELETE should be idempotent; safe to retry

### URL Conventions

- **Consistent Naming**: Use consistent, lowercase, hyphenated or underscored naming conventions for endpoints across the API
- **Plural Nouns**: Use plural nouns for resource endpoints (e.g., `/users`, `/products`) for consistency
- **Nested Resources**: Limit nesting depth to 2-3 levels maximum to keep URLs readable and maintainable
  - Good: `/users/:id/posts`
  - Avoid: `/organizations/:org_id/departments/:dept_id/teams/:team_id/members/:member_id`
- **Query Parameters**: Use query parameters for filtering, sorting, pagination, and search rather than creating separate endpoints
  - `/products?category=electronics&sort=price&limit=20&offset=0`

### HTTP Status Codes

- **Return appropriate, consistent HTTP status codes** that accurately reflect the response:
  - **200 OK**: Successful GET, PUT, PATCH, or DELETE
  - **201 Created**: Successful POST that creates a resource (include `Location` header)
  - **204 No Content**: Successful DELETE or update with no response body
  - **400 Bad Request**: Invalid request format, missing required fields, validation errors
  - **401 Unauthorized**: Missing or invalid authentication credentials
  - **403 Forbidden**: Authenticated but lacks permission for resource
  - **404 Not Found**: Resource doesn't exist
  - **409 Conflict**: Request conflicts with current state (duplicate, version mismatch)
  - **422 Unprocessable Entity**: Valid format but semantic errors (business rule violations)
  - **429 Too Many Requests**: Rate limit exceeded
  - **500 Internal Server Error**: Unexpected server error (log details, return generic message)
  - **503 Service Unavailable**: Temporary unavailability (maintenance, overload)

### Next.js API Routes (App Router)

- **Route Handlers**: Use Route Handlers in `app/api/` directory; file must be named `route.ts`
- **Export HTTP Methods**: Export functions named after HTTP methods (GET, POST, PUT, PATCH, DELETE)
```typescript
// app/api/users/route.ts
export async function GET(request: Request) {
  const users = await getUsers()
  return Response.json(users)
}

export async function POST(request: Request) {
  const body = await request.json()
  const user = await createUser(body)
  return Response.json(user, { status: 201 })
}
```

- **Dynamic Routes**: Use `[id]` for dynamic segments
```typescript
// app/api/users/[id]/route.ts
export async function GET(request: Request, { params }: { params: Promise<{ id: string }> }) {
  const { id } = await params
  const user = await getUser(id)
  if (!user) return new Response('Not Found', { status: 404 })
  return Response.json(user)
}
```

### Request Handling

- **Input Validation**: Validate all inputs with Zod or similar library before processing
```typescript
import { z } from 'zod'

const userSchema = z.object({
  name: z.string().min(1).max(100),
  email: z.string().email(),
  age: z.number().int().min(0).max(120).optional()
})

export async function POST(request: Request) {
  const body = await request.json()
  const result = userSchema.safeParse(body)

  if (!result.success) {
    return Response.json({ errors: result.error.issues }, { status: 400 })
  }

  const user = await createUser(result.data)
  return Response.json(user, { status: 201 })
}
```

- **Error Handling**: Return consistent error format across all endpoints
```typescript
interface APIError {
  error: {
    message: string
    code?: string
    details?: unknown
  }
}

// Usage
return Response.json({
  error: {
    message: 'Invalid email format',
    code: 'VALIDATION_ERROR',
    details: validationErrors
  }
}, { status: 400 })
```

- **Content Negotiation**: Accept and return JSON by default; support other formats if needed
- **Request Size Limits**: Enforce reasonable request body size limits (e.g., 10MB)

### Response Format

- **Consistent JSON Structure**: Use consistent response format across API
```typescript
// Success response
{
  "data": { /* resource or array of resources */ },
  "meta": { "total": 100, "page": 1, "limit": 20 }  // optional metadata
}

// Error response
{
  "error": {
    "message": "User not found",
    "code": "NOT_FOUND",
    "details": {}
  }
}
```

- **Timestamps**: Use ISO 8601 format for timestamps (`2024-01-15T10:30:00Z`)
- **Null vs Omit**: Be consistent; either include null fields or omit them entirely
- **Envelope**: Optionally wrap responses in `data` envelope for consistency

### Pagination

- **Offset-Based Pagination**: Simple and widely understood
```typescript
GET /api/products?limit=20&offset=40
// Response
{
  "data": [...],
  "meta": {
    "total": 150,
    "limit": 20,
    "offset": 40,
    "hasMore": true
  }
}
```

- **Cursor-Based Pagination**: Better for large datasets and real-time data
```typescript
GET /api/products?limit=20&cursor=abc123
// Response
{
  "data": [...],
  "meta": {
    "nextCursor": "xyz789",
    "hasMore": true
  }
}
```

- **Page-Based Pagination**: Alternative to offset
```typescript
GET /api/products?page=3&perPage=20
```

### Filtering & Sorting

- **Filtering**: Use query parameters for filtering
  - `/api/products?category=electronics&minPrice=100&maxPrice=500&inStock=true`
- **Sorting**: Support single or multiple field sorting
  - `/api/products?sort=price` (ascending)
  - `/api/products?sort=-price` (descending, with `-` prefix)
  - `/api/products?sort=category,-price` (multiple fields)
- **Search**: Use `q` or `search` parameter
  - `/api/products?q=laptop`

### Authentication & Authorization

- **Bearer Tokens**: Use Authorization header with JWT or similar
  - `Authorization: Bearer <token>`
- **API Keys**: For service-to-service communication
  - `X-API-Key: <key>` (custom header) or query param for limited cases
- **Session Cookies**: For browser-based applications with NextAuth
- **Resource-Level Authorization**: Check permissions before returning data
- **Rate Limiting**: Implement rate limiting per user/IP; return 429 when exceeded

### Rate Limiting Headers

- **Include rate limit information** in response headers to help clients manage their usage:
```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 87
X-RateLimit-Reset: 1640995200
```

### Versioning

- **URL Versioning**: `/api/v1/users`, `/api/v2/users` (simple, clear, widely used)
- **Header Versioning**: `Accept: application/vnd.api+json;version=2` (cleaner URLs)
- **Query Parameter**: `/api/users?version=2` (fallback, not recommended)
- **Breaking Changes**: Only version when introducing breaking changes
- **Deprecation**: Give advance notice; support old version for transition period

### CORS Configuration

- **Configure CORS**: Set appropriate headers for cross-origin requests
```typescript
export async function GET(request: Request) {
  const data = await getData()

  return new Response(JSON.stringify(data), {
    headers: {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': process.env.ALLOWED_ORIGIN || '*',
      'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type, Authorization',
    },
  })
}

export async function OPTIONS() {
  return new Response(null, {
    headers: {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type, Authorization',
    },
  })
}
```

### Caching

- **Cache-Control Headers**: Use appropriate caching headers
  - `Cache-Control: no-cache` - Revalidate before using cached response
  - `Cache-Control: private, max-age=3600` - Cache for 1 hour
  - `Cache-Control: public, max-age=86400` - Public cache for 24 hours
- **ETags**: Support ETags for conditional requests
- **Last-Modified**: Include Last-Modified header when appropriate

### Server Actions (Next.js)

- **Prefer Server Actions**: Use Server Actions for mutations instead of API routes when possible
- **'use server' Directive**: Mark functions with `'use server'` at top of file or function
```typescript
'use server'

import { z } from 'zod'
import { revalidatePath } from 'next/cache'

const createUserSchema = z.object({
  name: z.string().min(1),
  email: z.string().email(),
})

export async function createUser(formData: FormData) {
  const data = {
    name: formData.get('name'),
    email: formData.get('email'),
  }

  const result = createUserSchema.safeParse(data)
  if (!result.success) {
    return { error: 'Invalid input' }
  }

  const user = await db.user.create({ data: result.data })
  revalidatePath('/users')

  return { success: true, user }
}
```

- **Validation**: Always validate inputs in Server Actions
- **Error Handling**: Return error objects; don't throw (errors serialize poorly)
- **Revalidation**: Use `revalidatePath()` or `revalidateTag()` after mutations

### Security Best Practices

- **Input Sanitization**: Sanitize all user inputs to prevent injection attacks
- **SQL Injection**: Use parameterized queries or ORM; never concatenate SQL
- **XSS Prevention**: Escape output; use Content Security Policy headers
- **CSRF Protection**: Use CSRF tokens for state-changing operations
- **Secrets Management**: Never expose secrets in responses; use environment variables
- **HTTPS Only**: Enforce HTTPS in production; use HSTS header
- **Dependency Scanning**: Regularly scan for vulnerable dependencies

### Logging & Monitoring

- **Request Logging**: Log all API requests with method, path, status code, duration
- **Error Logging**: Log errors with stack traces and context; don't expose to client
- **Performance Monitoring**: Track response times; alert on slow endpoints
- **Security Events**: Log authentication failures, rate limit hits, suspicious activity
- **Correlation IDs**: Use request IDs to trace requests across services

### API Documentation

- **OpenAPI/Swagger**: Generate OpenAPI spec for API documentation
- **Example Requests**: Provide example requests and responses for each endpoint
- **Error Codes**: Document all possible error codes and their meanings
- **Rate Limits**: Document rate limit policies
- **Authentication**: Clear documentation on authentication methods
- **Changelog**: Maintain changelog for API changes

### Testing

- **Unit Tests**: Test business logic independently of HTTP layer
- **Integration Tests**: Test full request/response cycle
- **Contract Tests**: Verify API responses match documented schema
- **Load Tests**: Test performance under load; identify bottlenecks
- **Security Tests**: Test for common vulnerabilities (injection, auth bypass)

### Performance Optimization

- **Database Indexing**: Index columns used in WHERE, JOIN, ORDER BY clauses
- **N+1 Queries**: Avoid N+1 queries; use eager loading or data loader pattern
- **Response Compression**: Enable gzip/brotli compression for responses
- **CDN**: Use CDN for static API responses when appropriate
- **Database Connection Pooling**: Reuse database connections; don't create per request
- **Caching**: Cache expensive queries; invalidate on updates

### Common Anti-Patterns

- **Ignoring HTTP Semantics**: Using POST for everything; not using appropriate status codes
- **Exposing Internal IDs**: Use UUIDs or obfuscated IDs instead of sequential integers
- **No Pagination**: Always paginate list endpoints; unbounded queries cause issues
- **Verbose Responses**: Only return necessary data; support field selection if needed
- **Synchronous Long Operations**: Use background jobs for long-running tasks; return 202 Accepted
- **Leaking Error Details**: Don't expose stack traces or internal errors to clients
- **No Versioning Strategy**: Plan for versioning from the start
