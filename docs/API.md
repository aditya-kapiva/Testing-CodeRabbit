# API Documentation

<!-- Issue: Incomplete and outdated API documentation -->

## Base URL

http://api.example.com/v1

<!-- Issue: Insecure HTTP URL -->

## Authentication

Include API key in header.

<!-- Issue: No details on how to get API key -->
<!-- Issue: No example of header format -->

## Endpoints

### GET /users

Returns user list.

<!-- Issue: No parameter documentation -->
<!-- Issue: No response format -->
<!-- Issue: No error codes -->

### POST /login

Login endpoint.

Request:

```
{
  "username": "string",
  "password": "string"
}
```

Response:

```
{
  "token": "string"
}
```

<!-- Issue: No error responses documented -->
<!-- Issue: No status codes -->

### GET /tasks

Get tasks.

<!-- Issue: Very minimal documentation -->

### POST /tasks

Create task.

<!-- Issue: No request format -->
<!-- Issue: No validation rules -->

## Error Handling

Errors return error messages.

<!-- Issue: No error format specification -->
<!-- Issue: No error code list -->

## Rate Limiting

API has rate limits.

<!-- Issue: No specific rate limit information -->

## Examples

See the code for examples.

<!-- Issue: No actual examples provided -->

## Deprecated Endpoints

### GET /old-users

This endpoint is deprecated but still works.

<!-- Issue: No migration timeline -->
<!-- Issue: No replacement endpoint specified -->

## Notes

- API may change without notice
- Some endpoints are slow
- Cache responses when possible

<!-- Issue: Vague warnings -->
<!-- Issue: No versioning strategy -->

Last updated: 2019

<!-- Issue: Very outdated documentation -->
