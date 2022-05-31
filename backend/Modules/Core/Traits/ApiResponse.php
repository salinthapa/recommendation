<?php

namespace Modules\Core\Traits;

use Illuminate\Http\JsonResponse;

trait ApiResponse
{
    public function response(bool $status, string $message, $payload = null, int $response_code = 200): JsonResponse
    {
        $response = [
            "status" => $status ? "success" : "error",
            "payload" => is_object($payload) ? $payload->response()->getData(true) : ["data" => $payload],
            "message" => json_decode($message) ?? $message
        ];

        if ( $payload == null ) unset($response["payload"]);
        return response()->json($response, $response_code);
    }

    public function successResponse($payload, string $message, int $response_code = 200): JsonResponse
    {
        return $this->response(true, $message, $payload, $response_code);
    }

    public function errorResponse(string $message, int $response_code = 500): JsonResponse
    {
        return $this->response(false, $message, null, $response_code);
    }

    public function successResponseMessage(string $message, int $response_code = 200): JsonResponse
    {
        return $this->response(true, $message, null, $response_code);
    }
}
