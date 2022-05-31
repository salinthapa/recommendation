<?php

namespace Modules\Gym\Entities;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Gym extends Model
{
    use HasFactory;

    protected $guarded = [];
    protected $casts = [
        "permissions" => "array"
    ];

    protected static function newFactory()
    {
        return \Modules\Gym\Database\factories\GymFactory::new();
    }
}
