<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use App\Models\Distrito;

class Provincia extends Model
{
    use HasFactory;

    protected $table = 'provincia';

    protected $fillable = [
        'nome',
        'pais_id',
    ];

    public $timestamps = false;

    /**
     * Get the pais that owns the provincia.
     */
    public function pais(): BelongsTo
    {
        return $this->belongsTo(Pais::class, 'pais_id');
    }

    /**
     * Get the distritos for the provincia.
     */
    public function distrito(): HasMany
    {
        return $this->hasMany(Distrito::class, 'provincia_id');
    }
}
