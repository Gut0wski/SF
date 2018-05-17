<?php

namespace AppBundle\Form;

use AppBundle\Entity\Messages;
use AppBundle\Entity\Users;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Component\Form\Extension\Core\Type\TextareaType;
use Symfony\Component\Form\Extension\Core\Type\SubmitType;
use Symfony\Bridge\Doctrine\Form\Type\EntityType;
use Symfony\Component\OptionsResolver\OptionsResolver;
use Doctrine\ORM\EntityRepository;

/**
 * Класс формы создания новго сообщения пользователю
 * @package AppBundle\Form
 */
class Letter extends AbstractType
{
    /**
     * @param FormBuilderInterface $builder
     * @param array $options
     */
    public function buildForm(FormBuilderInterface $builder, array $options)
    {
        dump($options['user_id']);

        $builder
            ->add('recipient', EntityType::class, [
                'class' => Users::class,
                'query_builder' => function (EntityRepository $er) use ($options) {
                    return $er->createQueryBuilder('u')
                        ->where('u.id != :id')
                        ->setParameter('id', $options['user_id'])
                        ->orderBy('u.username');
                },
                'choice_label' => 'username',
                'label' => 'Получатель',
                'attr' => ['class' => 'form-control']
            ])
            ->add('subject', TextType::class, [
                'label' => 'Тема',
                'attr' => ['class' => 'form-control']
            ])
            ->add('text', TextareaType::class, [
                'label' => 'Текст',
                'attr' => ['class' => 'form-control']
            ])
            ->add('submit', SubmitType::class, [
                'attr' => [
                    'class' => 'btn btn-success pull-right'
                ],
                'label' => 'Отправить'
            ]);
    }

    /**
     * @param OptionsResolver $resolver
     */
    public function configureOptions(OptionsResolver $resolver)
    {
        $resolver->setDefaults([
            'data_class' => Messages::class,
            'user_id' => null
        ]);
    }
}