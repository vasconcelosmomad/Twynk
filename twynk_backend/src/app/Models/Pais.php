<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Pais extends Model
{
    use HasFactory;

    protected $table = 'pais';

    protected $fillable = [
        'nome',
    ];

    public $timestamps = false;

    /**
     * Get the provincias for the pais.
     */
    public function provincias(): HasMany
    {
        return $this->hasMany(Provincia::class, 'pais_id');
    }
}
