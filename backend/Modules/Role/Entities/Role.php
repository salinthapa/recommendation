<?php

namespace Modules\Role\Entities;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Role extends Model
{
    use HasFactory;

    protected $guarded = [];
    protected $casts = [
        "permissions" => "array"
    ];
    
    protected static function newFactory()
    {
        return \Modules\Role\Database\factories\RoleFactory::new();
    }
}
