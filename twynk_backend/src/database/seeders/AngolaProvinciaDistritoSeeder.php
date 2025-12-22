<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;
use App\Models\Pais;

class AngolaProvinciaDistritoSeeder extends Seeder
{
    public function run(): void
    {
        DB::statement('SET FOREIGN_KEY_CHECKS=0;');

        // Garante que o país Angola exista e obtém o seu ID real
        $pais = Pais::firstOrCreate(
            ['nome' => 'Angola'],
            ['status' => 'ativo']
        );

        // Limpa distritos e províncias apenas deste país
        DB::table('distrito')
            ->whereIn('provincia_id', function ($q) use ($pais) {
                $q->select('id')->from('provincia')->where('pais_id', $pais->id);
            })->delete();

        DB::table('provincia')->where('pais_id', $pais->id)->delete();

        DB::statement('SET FOREIGN_KEY_CHECKS=1;');

        $now = Carbon::now();

        // ========================
        // PROVÍNCIAS + MUNICÍPIOS
        // ========================
        $dados = [
            'Luanda' => [
                'Belas',
                'Cacuaco',
                'Cazenga',
                'Ícolo e Bengo',
                'Luanda',
                'Kilamba Kiaxi',
                'Talatona',
                'Viana',
            ],

            'Benguela' => [
                'Benguela',
                'Baía Farta',
                'Balombo',
                'Bocoio',
                'Caimbambo',
                'Catumbela',
                'Chongoroi',
                'Cubal',
                'Ganda',
                'Lobito',
            ],

            'Huíla' => [
                'Lubango',
                'Caconda',
                'Caluquembe',
                'Chibia',
                'Chicomba',
                'Chipindo',
                'Humpata',
                'Jamba',
                'Matala',
                'Quilengues',
                'Quipungo',
            ],

            'Huambo' => [
                'Huambo',
                'Bailundo',
                'Caála',
                'Catchiungo',
                'Ecunha',
                'Londuimbali',
                'Longonjo',
                'Mungo',
                'Tchicala-Tcholohanga',
                'Tchindjenje',
                'Ucuma',
            ],

            'Bié' => [
                'Cuito',
                'Andulo',
                'Camacupa',
                'Catabola',
                'Chinguar',
                'Chitembo',
                'Cuemba',
                'Cunhinga',
                'Nharêa',
            ],

            'Malanje' => [
                'Malanje',
                'Cacuso',
                'Calandula',
                'Cambundi-Catembo',
                'Cangandala',
                'Caombo',
                'Cuaba Nzogo',
                'Kunda dya Baze',
                'Luquembo',
                'Marimba',
                'Massango',
                'Mucari',
                'Quela',
            ],

            'Uíge' => [
                'Uíge',
                'Alto Cauale',
                'Ambuíla',
                'Bembe',
                'Buengas',
                'Bungo',
                'Damba',
                'Macocola',
                'Milunga',
                'Mucaba',
                'Negage',
                'Puri',
                'Quimbele',
                'Sanza Pombo',
                'Songo',
                'Maquela do Zombo',
            ],

            'Kwanza Norte' => [
                'Cazengo',
                'Cambambe',
                'Golungo Alto',
                'Gonguembo',
                'Lucala',
                'Quiculungo',
                'Samba Caju',
            ],

            'Kwanza Sul' => [
                'Sumbe',
                'Amboim',
                'Cassongue',
                'Cela',
                'Conda',
                'Ebo',
                'Libolo',
                'Mussende',
                'Porto Amboim',
                'Quibala',
                'Quilenda',
                'Seles',
                'Waku-Kungo',
            ],

            'Cabinda' => [
                'Cabinda',
                'Cacongo',
                'Buco-Zau',
                'Belize',
            ],
        ];

        // ========================
        // INSERT PROVÍNCIAS + DISTRITOS
        // ========================
        foreach ($dados as $provinciaNome => $distritos) {

            $provinciaId = DB::table('provincia')->insertGetId([
                'nome'    => $provinciaNome,
                'pais_id' => $pais->id,
            ]);

            foreach ($distritos as $distrito) {
                DB::table('distrito')->insert([
                    'nome'         => $distrito,
                    'provincia_id' => $provinciaId,
                ]);
            }
        }
    }
}
