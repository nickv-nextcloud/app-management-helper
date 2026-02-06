<?php

declare(strict_types=1);
/**
 * SPDX-FileCopyrightText: 2024 Joas Schilling <coding@schilljs.com>
 * SPDX-License-Identifier: AGPL-3.0-or-later
 */

$content = file_get_contents($argv[1] . '/appinfo/info.xml');
$xml = simplexml_load_string($content);
$appVersion = (string) $xml->version;

$versions = explode('.', $appVersion, 3);

$versions[2] = strtolower($versions[2]);
if (str_contains($versions[2], 'alpha')
	|| str_contains($versions[2], 'beta')
	|| str_contains($versions[2], 'rc')
	|| str_contains($versions[2], 'dev')) {
	$versions[2] = (string)((int)$versions[2]);
} else {
	return;
}

$newVersion = implode('.', $versions);
$content = str_replace('<version>' . $appVersion . '</version>', '<version>' . $newVersion . '</version>', $content);

file_put_contents($argv[1] . '/appinfo/info.xml', $content);
