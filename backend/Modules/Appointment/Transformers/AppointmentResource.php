<?php

namespace Modules\Appointment\Transformers;

use Illuminate\Http\Resources\Json\JsonResource;
use Modules\User\Transformers\UserResource;

class AppointmentResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @param  \Illuminate\Http\Request
     * @return array
     */
    public function toArray($request)
    {
        return [
            "id" => $this->id,
            "trainer" => new UserResource($this->whenLoaded("trainer")),
            "trainer_id" => $this->trainer_id,
            "customer" => new UserResource($this->whenLoaded("customer")),
            "customer_id" => $this->customer_id,
            "appointment_date" => $this->appointment_date,
            "appointment_time" => $this->appointment_time,
            "status" => $this->status,
            "created_at" => $this->created_at->format("dS F, Y H:i a"),
            "created_at_diff" => $this->created_at->diffForHumans()
        ];
    }
}
