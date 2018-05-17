<?php

namespace AppBundle\Controller;

use AppBundle\Form\Map;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Request;

/**
 * Контроллер карты
 * @package AppBundle\Controller
 */
class MapController extends Controller
{
    /**
     * Отображение карты
     * @return \Symfony\Component\HttpFoundation\Response
     */
    public function viewAction()
    {
        $map = $this->getDoctrine()
            ->getRepository("AppBundle:Settings")
            ->findOneByParameter('map');
        return $this->render("@App/map/view.html.twig", compact('map'));
    }

    /**
     * Редактирование карты
     * @param Request $request
     * @return \Symfony\Component\HttpFoundation\Response
     */
    public function editAction(Request $request)
    {
        $index = $this->getDoctrine()
            ->getRepository("AppBundle:Settings")
            ->findOneByParameter('map');
        if (!$index) {
            throw $this->createAccessDeniedException('У вас нет доступа к этой странице!');
        }
        $form = $this->createForm(Map::class, $index);
        $form->handleRequest($request);
        if ($form->isSubmitted() && $form->isValid()) {
            $em = $this->getDoctrine()->getManager();
            $em->persist($index);
            $em->flush();
            return $this->redirectToRoute('map');
        }
        return $this->render('@App/map/edit.html.twig', [
            'form' => $form->createView()
        ]);
    }
}